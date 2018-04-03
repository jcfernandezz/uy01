--------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('ucfe.fCfdiRelacionados') IS NOT NULL
   DROP FUNCTION ucfe.fCfdiRelacionados
GO

create function ucfe.fCfdiRelacionados(@soptype smallint, @p_sopnumbe varchar(21))
returns table
as
--Propósito. Obtiene la relación con otros documentos. 
--		Si la factura relaciona a otra factura o nd, consultar el tracking number
--Requisito. 
--24/10/17 jcf Creación
--
return(
			--ND relaciona a factura
			select ROW_NUMBER() OVER(ORDER BY da.tracking_number asc) orden, 
				pr.param5 tipoDocumento,
				ud.serieCfeRef, ud.nroCfeRef, da.tracking_number sopnumbeRef
			from sop10107 da	--
				inner join ucfe.vwCfdiSopTransaccionesVenta ud
					on ud.sopnumbe = da.tracking_number
					and ud.soptype = 3
				outer apply ucfe.fCfdiParametros('na', 'na', 'na', 'na', 'E_'+ud.docid, 'na', 'UCFE') pr
			where da.sopnumbe = @p_sopnumbe
			and da.soptype = @soptype
			and @soptype = 3

			union all

			--NC o devolución que relaciona a factura o nd
			SELECT ROW_NUMBER() OVER(ORDER BY ap.aptodcnm asc) orden, 
				pr.param5 tipoDocumento,
				ud.serieCfeRef, ud.nroCfeRef, ap.aptodcnm 
			from dbo.vwRmTrxAplicadas  ap
				inner join ucfe.vwCfdiSopTransaccionesVenta ud
					on ud.sopnumbe = ap.aptodcnm 
					and ud.soptype = 3
				outer apply ucfe.fCfdiParametros('na', 'na', 'na', 'na', 'E_'+ud.docid, 'na', 'UCFE') pr
			where ap.APFRDCTY = @soptype+4										--tipo nc es 8 en AR
			AND ap.apfrdcnm = @p_sopnumbe
			and @soptype = 4
)	
go

IF (@@Error = 0) PRINT 'Creación exitosa de: fCfdiRelacionados()'
ELSE PRINT 'Error en la creación de: fCfdiRelacionados()'
GO

--------------------------------------------------------------------------------------------------------
--IF (OBJECT_ID ('ucfe.vwCfdiRelacionados', 'V') IS NULL)
--   exec('create view ucfe.vwCfdiRelacionados as SELECT 1 as t');
--go

--alter view ucfe.vwCfdiRelacionados
--as

--select rel.orden, rel.tipoDocumento, rel.serieCfeRef, rel.nroCfeRef, rel.sopnumbeRef
--from sop30200 sop
--	cross apply ucfe.fCfdiRelacionados(sop.soptype, sop.sopnumbe) rel

--go

--IF (@@Error = 0) PRINT 'Creación exitosa de la función: vwCfdiRelacionados ()'
--ELSE PRINT 'Error en la creación de la función: vwCfdiRelacionados ()'
--GO

--------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('ucfe.fCfdiRelacionadosXML') IS NOT NULL
   DROP FUNCTION ucfe.fCfdiRelacionadosXML
GO

create function ucfe.fCfdiRelacionadosXML(@soptype smallint, @p_sopnumbe varchar(21), @p_commntid varchar(15), @p_comment_1 varchar(50))
returns xml 
as
--Propósito. Obtiene la relación con otros documentos en formato XML. 
--Requisito. En caso de referenciar una factura electrónica, puede hacer uso de p_commntid.
--27/03/18 jcf Creación
--
begin

	declare @cncp xml;
		WITH XMLNAMESPACES (DEFAULT 'http://cfe.dgi.gub.uy')
		select @cncp = (
			select 	rf.orden		'NroLinRef',
				case when left(@p_commntid, 1) = '1' then null
					else rf.tipoDocumento	
				end 'TpoDocRef',
				case when left(@p_commntid, 1) = '1' then null
					else rf.serieCfeRef			
				end 'Serie', 
				case when left(@p_commntid, 1) = '1' then null
					else rf.nroCfeRef			
				end 'NroCFERef',
				case when left(@p_commntid, 1) = '1' then '1'
					else null
				end 'Indglobal',
				case when left(@p_commntid, 1) = '1' then rtrim(@p_comment_1)
					else null
				end 'RazonRef'
			from ucfe.fCfdiRelacionados(@soptype, @p_sopnumbe) rf
			FOR XML path('Referencia'), root('Referencia')
		)
	
	return @cncp
end
go

IF (@@Error = 0) PRINT 'Creación exitosa de: fCfdiRelacionadosXML()'
ELSE PRINT 'Error en la creación de: fCfdiRelacionadosXML()'
GO

--------------------------------------------------------------------------------------------------------