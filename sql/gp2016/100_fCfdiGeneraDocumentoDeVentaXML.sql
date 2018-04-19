--------------------------------------------------------------------------------------------------------------------
IF (OBJECT_ID ('ucfe.vwCfdiSopLineasTrxVentas', 'V') IS NULL)
   exec('create view ucfe.vwCfdiSopLineasTrxVentas as SELECT 1 as t');
go

alter view ucfe.vwCfdiSopLineasTrxVentas as
--Propósito. Obtiene todas las líneas de facturas de venta SOP
--			Incluye descuentos
--Requisito. 
--26/03/18 JCF Creación cfe
--
select dt.soptype, dt.sopnumbe, dt.LNITMSEQ, dt.ITEMNMBR, dt.ShipToName,
	dt.QUANTITY, dt.UOFM,
	dt.ITEMDESC, 
	dt.ORUNTPRC, dt.OXTNDPRC, dt.CMPNTSEQ, 
	dt.QUANTITY * dt.ORUNTPRC importe, 
	isnull(ma.ITMTRKOP, 1) ITMTRKOP,		--3 lote, 2 serie, 1 nada
	ma.uscatvls_5, 
	ma.uscatvls_6, 
	dt.ormrkdam,
	dt.QUANTITY * dt.ormrkdam descuento
from SOP30300 dt
left join iv00101 ma				--iv_itm_mstr
	on ma.ITEMNMBR = dt.ITEMNMBR

go	

IF (@@Error = 0) PRINT 'Creación exitosa de: vwCfdiSopLineasTrxVentas'
ELSE PRINT 'Error en la creación de: vwCfdiSopLineasTrxVentas'
GO

----------------------------------------------------------------------------------------------------
IF OBJECT_ID ('ucfe.fCfdiImpuestosSop') IS NOT NULL
   DROP FUNCTION ucfe.fCfdiImpuestosSop
GO

create function ucfe.fCfdiImpuestosSop(@SOPNUMBE char(21), @DOCTYPE smallint, @LNITMSEQ int, @prefijo varchar(15), @tipoPrecio varchar(10))
returns table
as
--Propósito. Detalle de impuestos en trabajo e históricos de SOP. Filtra los impuestos requeridos por @prefijo
--Requisitos. Los impuestos iva deben ser configurados con un prefijo constante
--26/03/18 JCF Creación cfe
--
return
(
	select imp.soptype, imp.sopnumbe, imp.taxdtlid, imp.staxamnt, imp.orslstax, imp.tdttxsls, imp.ortxsls,
			tx.NAME, tx.cntcprsn, tx.TXDTLPCT
	from sop10105 imp
		inner join tx00201 tx
		on tx.taxdtlid = imp.taxdtlid
		and tx.cntcprsn like @tipoPrecio
	where imp.sopnumbe = @SOPNUMBE
	and imp.soptype = @DOCTYPE
	and imp.LNITMSEQ = @LNITMSEQ
	and imp.taxdtlid like @prefijo + '%'
)

go


IF (@@Error = 0) PRINT 'Creación exitosa de la función: fCfdiImpuestosSop()'
ELSE PRINT 'Error en la creación de la función: fCfdiImpuestosSop()'
GO

--------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('ucfe.fCfdiConceptos') IS NOT NULL
   DROP FUNCTION ucfe.fCfdiConceptos
GO

create function ucfe.fCfdiConceptos(@SOPNUMBE char(21), @DOCTYPE smallint)
returns table
as

--Propósito. Obtiene las líneas de una factura 
--			Elimina carriage returns, line feeds, tabs, secuencias de espacios y caracteres especiales.
--Requisito. Se asume que una línea de factura tiene una línea de impuesto
--26/03/18 JCF Creación cfe
--
return
		select ROW_NUMBER() OVER(ORDER BY Concepto.LNITMSEQ asc) id, 
			case when isnull(exe.ortxsls, 0) != 0 
				then left(exe.name, 1)
				else '0'	--exento predeterminado
			end indicadorFactura,
			Concepto.ITEMDESC, 
			ucfe.fCfdReemplazaSecuenciaDeEspacios(ltrim(rtrim(ucfe.fCfdReemplazaCaracteresNI(Concepto.ITEMDESC))), 10) DescripcionItem, 
			Concepto.QUANTITY cantidad, 
			Concepto.UOFM,
			Concepto.ORUNTPRC, 
			Concepto.descuento,
			Concepto.OXTNDPRC,
			Concepto.soptype, Concepto.sopnumbe, Concepto.LNITMSEQ, Concepto.ITEMNMBR

		from ucfe.vwCfdiSopLineasTrxVentas Concepto
			outer apply ucfe.fCfdiParametros('na', 'V_PREFEXENTO', 'na', 'na', 'na', 'na', 'UCFE') pr
			outer apply ucfe.fCfdiImpuestosSop(Concepto.SOPNUMBE, Concepto.soptype, Concepto.LNITMSEQ, pr.param2, '%') exe --exento
		where Concepto.CMPNTSEQ = 0					--a nivel kit
		and Concepto.sopnumbe = @SOPNUMBE
		and Concepto.soptype = @DOCTYPE

go

IF (@@Error = 0) PRINT 'Creación exitosa de: fCfdiConceptos()'
ELSE PRINT 'Error en la creación de: fCfdiConceptos()'
GO

--------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('ucfe.fCfdiConceptosXML') IS NOT NULL
   DROP FUNCTION ucfe.fCfdiConceptosXML
GO

create function ucfe.fCfdiConceptosXML(@p_soptype smallint, @p_sopnumbe varchar(21), @DOCID char(15))
returns xml 
as
--Propósito. Obtiene las líneas de una factura en formato xml para ucfe
--			Elimina carriage returns, line feeds, tabs, secuencias de espacios y caracteres especiales.
--27/03/18 JCF Creación cfe
--
begin
	declare @cncp xml;
	WITH XMLNAMESPACES (DEFAULT 'http://cfe.dgi.gub.uy')
	select @cncp = (
		select 
			Concepto.id								'NroLinDet',
			Concepto.indicadorFactura				'IndFact',
			Concepto.DescripcionItem				'NomItem', 
			Concepto.Cantidad						'Cantidad', 
			rtrim(Concepto.UOFM)					'UniMed', 
			cast(Concepto.ORUNTPRC as numeric(13, 2)) 'PrecioUnitario',
			case when Concepto.Descuento = 0 then null
				else cast(Concepto.Descuento as numeric(17, 2))		
			end										'Descuento',
			cast(Concepto.OXTNDPRC as numeric(17,2)) 'MontoItem'
		from ucfe.fCfdiConceptos(@p_sopnumbe, @p_soptype) Concepto
		FOR XML path('Item') , root('Detalle')
	)
	return @cncp
end
go

IF (@@Error = 0) PRINT 'Creación exitosa de: fCfdiConceptosXML()'
ELSE PRINT 'Error en la creación de: fCfdiConceptosXML()'
GO



-----------------------------------------------------------------------------------------
IF OBJECT_ID ('ucfe.fCfdiGeneraDocumentoDeVentaXML') IS NOT NULL
   DROP FUNCTION ucfe.fCfdiGeneraDocumentoDeVentaXML
GO

create function ucfe.fCfdiGeneraDocumentoDeVentaXML (@soptype smallint, @sopnumbe varchar(21))
returns xml 
as
--Propósito. Elabora un comprobante xml para factura electrónica ucfe
--Requisitos. Se asume que todos los items son exentos
--27/03/18 JCF Creación cfe
--18/04/18 jcf Agrega filtro estadoContabilizado
--
begin
	declare @cfd xml;
	WITH XMLNAMESPACES
	(
		DEFAULT 'http://cfe.dgi.gub.uy'
	)
	select @cfd = 
	(
	select 
		emi.[version]										'@version',

		rtrim(pr.param5)									'eTck/Encabezado/IdDoc/TipoCFE',
		replace(convert(varchar(20), tv.DOCDATE, 102), '.', '-')	'eTck/Encabezado/IdDoc/FchEmis',
		1													'eTck/Encabezado/IdDoc/FmaPago',

		emi.TAXREGTN										'eTck/Encabezado/Emisor/RUCEmisor',
		emi.CMPNYNAM										'eTck/Encabezado/Emisor/RznSoc',
		emi.sucursal										'eTck/Encabezado/Emisor/CdgDGISucur',
		emi.ADDRESS1										'eTck/Encabezado/Emisor/DomFiscal',
		emi.city											'eTck/Encabezado/Emisor/Ciudad',
		emi.[state]											'eTck/Encabezado/Emisor/Departamento',

		rtrim(left(tv.TAXEXMT2, 1))							'eTck/Encabezado/Receptor/TipoDocRecep',
		case when rtrim(tv.ccode) = '' then 'UY' 
			else rtrim(tv.ccode) 
			end												'eTck/Encabezado/Receptor/CodPaisRecep',
		case when rtrim(tv.ccode) in ( '', 'UY') then rtrim(tv.TXRGNNUM)
			else null
			end												'eTck/Encabezado/Receptor/DocRecep',
		case when rtrim(tv.ccode) in ( '', 'UY') then null
			else rtrim(tv.TXRGNNUM)
			end												'eTck/Encabezado/Receptor/DocRecepExt',

		tv.curncyid											'eTck/Encabezado/Totales/TpoMoneda',

		case when tv.curncyid = 'UYU'
			then null
			else cast(tv.xchgrate as numeric(7,3))
		end													'eTck/Encabezado/Totales/TpoCambio',

		cast(ld.MntNoGrv - tv.descuento as numeric(17,2))	'eTck/Encabezado/Totales/MntNoGrv',

		cast(tv.total  as numeric(17, 2))					'eTck/Encabezado/Totales/MntTotal',

		ld.cantLinDet										 'eTck/Encabezado/Totales/CantLinDet',

		cast(tv.total  as numeric(17, 2))					'eTck/Encabezado/Totales/MntPagar',
		ucfe.fCfdiConceptosXML(tv.soptype, tv.sopnumbe, tv.docid) 'eTck',
		ucfe.fCfdiRelacionadosXML(tv.soptype, tv.sopnumbe, tv.commntid, tv.comment_1) 'eTck'

	from ucfe.vwCfdiSopTransaccionesVenta tv
		outer apply ucfe.fCfdiEmisor() emi
		outer apply ucfe.fCfdiParametros('na', 'V_PREFEXENTO', 'na', 'na', 'E_'+tv.docid, 'na', 'UCFE') pr
		outer apply (select count(id) cantLinDet, 
						sum(case when indicadorFactura = '1' then OXTNDPRC else 0 end) MntNoGrv
					from  ucfe.fCfdiConceptos(tv.sopnumbe, tv.soptype)	
					) ld
	where tv.sopnumbe =	@sopnumbe
	and tv.soptype = @soptype
	and tv.estadoContabilizado = 'contabilizado'
	FOR XML path('CFE'), type
	);
	--select @cfd;

	return @cfd;
end
go

IF (@@Error = 0) PRINT 'Creación exitosa de la función: fCfdiGeneraDocumentoDeVentaXML ()'
ELSE PRINT 'Error en la creación de la función: fCfdiGeneraDocumentoDeVentaXML ()'
GO
--------------------------------------------------------------------------------------------------------------------

