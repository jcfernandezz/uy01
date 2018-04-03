-----------------------------------------------------------------------------------------
IF (OBJECT_ID ('ucfe.vwCfeEnEspera', 'V') IS NULL)
   exec('create view ucfe.vwCfeEnEspera as SELECT 1 as t');
go

alter view ucfe.vwCfeEnEspera as
--Propósito. Lista los comprobantes que se deben enviar a UCFE
--Usado por. 
--Requisitos. Posibles estados:
--		Vacío. Está listo para enviar a UCFE
--		CFE_LISTO. Está listo para enviar a UCFE
--27/03/18 jcf Creación cfe Uruguay
--

	select  tv.tipoCfe, tv.codTerminal, tv.codComercio, tv.sopnumbe, tv.SOPTYPE, tv.docid
	from ucfe.vwComprobantesFiscalesElectronicos tv
	where isnull(tv.usrtab01, '') in ('CFE_ENESPERA', 'DGI2_ENESPERA')

go

IF (@@Error = 0) PRINT 'Creación exitosa de la vista: vwCfeEnEspera'
ELSE PRINT 'Error en la creación de la vista: vwCfeEnEspera'
GO
