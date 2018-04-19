-----------------------------------------------------------------------------------------
IF (OBJECT_ID ('ucfe.vwCfePendientesDeEnviar', 'V') IS NULL)
   exec('create view ucfe.vwCfePendientesDeEnviar as SELECT 1 as t');
go

alter view ucfe.vwCfePendientesDeEnviar as
--Propósito. Lista los comprobantes que se deben enviar a UCFE
--Usado por. 
--Requisitos. Posibles estados:
--		Vacío. Está listo para enviar a UCFE
--		CFE_LISTO. Está listo para enviar a UCFE
--27/03/18 jcf Creación cfe Uruguay
--19/04/18 jcf Mostrar sólo los comprobantes contabilizados
--

	select  tv.tipoCfe, tv.codTerminal, tv.codComercio, tv.sopnumbe, tv.SOPTYPE, tv.docid, 'CFE_ENESPERA' siguienteStatusCfe,
		ucfe.fCfdiGeneraDocumentoDeVentaXML (tv.soptype, tv.sopnumbe) docXml, ac.jrnentry
	from ucfe.vwComprobantesFiscalesElectronicos tv
		cross apply dbo.fnGlGetPrimerAsientoContableDeTrx(3, tv.soptype, tv.sopnumbe) ac
	where isnull(tv.usrtab01, '') in ('', 'CFE_LISTO')
	and ac.origen in ('Histórico', 'Abrir')
	  
go

IF (@@Error = 0) PRINT 'Creación exitosa de la vista: vwCfePendientesDeEnviar'
ELSE PRINT 'Error en la creación de la vista: vwCfePendientesDeEnviar'
GO
