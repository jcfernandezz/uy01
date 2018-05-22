-----------------------------------------------------------------------------------------
IF (OBJECT_ID ('ucfe.vwComprobantesFiscalesElectronicos', 'V') IS NULL)
   exec('create view ucfe.vwComprobantesFiscalesElectronicos as SELECT 1 as t');
go

alter view ucfe.vwComprobantesFiscalesElectronicos as
--Propósito. Lista los comprobantes que se deben procesar
--Usado por. 
--Requisitos. 
--27/03/18 jcf Creación cfe Uruguay
--17/05/18 jcf Agrega comment_1, pymtrmid
--

	select  pr.param5 tipoCfe, pr.param1 codTerminal, pr.param2 codComercio, tv.sopnumbe, tv.SOPTYPE, tv.docid, 
		tv.usrtab01, isnull(tv.usrtab01, '') statusCfe, tv.USRDEF05, tv.comment_1, tv.pymtrmid, 
		ucfe.fCfdiGeneraDocumentoDeVentaXML (tv.soptype, tv.sopnumbe) docXml
	from ucfe.vwCfdiSopTransaccionesVenta tv
		cross apply ucfe.fCfdiParametros('CODTERMINAL', 'CODCOMERCIO', 'na', 'na', 'E_'+tv.docid, 'na', 'UCFE') pr
	where tv.estadoContabilizado = 'contabilizado'
	  AND tv.voidstts = 0
	  and pr.param5 not like 'no existe tag%'

go

IF (@@Error = 0) PRINT 'Creación exitosa de la vista: vwComprobantesFiscalesElectronicos'
ELSE PRINT 'Error en la creación de la vista: vwComprobantesFiscalesElectronicos'
GO
