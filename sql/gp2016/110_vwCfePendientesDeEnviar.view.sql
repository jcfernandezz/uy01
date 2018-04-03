-----------------------------------------------------------------------------------------
IF (OBJECT_ID ('ucfe.vwCfePendientesDeEnviar', 'V') IS NULL)
   exec('create view ucfe.vwCfePendientesDeEnviar as SELECT 1 as t');
go

alter view ucfe.vwCfePendientesDeEnviar as
--Prop�sito. Lista los comprobantes que se deben enviar a UCFE
--Usado por. 
--Requisitos. Posibles estados:
--		Vac�o. Est� listo para enviar a UCFE
--		CFE_LISTO. Est� listo para enviar a UCFE
--27/03/18 jcf Creaci�n cfe Uruguay
--

	select  tv.tipoCfe, tv.codTerminal, tv.codComercio, tv.sopnumbe, tv.SOPTYPE, tv.docid, 'CFE_ENESPERA' siguienteStatusCfe,
		ucfe.fCfdiGeneraDocumentoDeVentaXML (tv.soptype, tv.sopnumbe) docXml
	from ucfe.vwComprobantesFiscalesElectronicos tv
	where isnull(tv.usrtab01, '') in ('', 'CFE_LISTO')
	  
go

IF (@@Error = 0) PRINT 'Creaci�n exitosa de la vista: vwCfePendientesDeEnviar'
ELSE PRINT 'Error en la creaci�n de la vista: vwCfePendientesDeEnviar'
GO
