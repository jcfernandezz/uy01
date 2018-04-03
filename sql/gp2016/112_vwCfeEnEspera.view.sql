-----------------------------------------------------------------------------------------
IF (OBJECT_ID ('ucfe.vwCfeEnEspera', 'V') IS NULL)
   exec('create view ucfe.vwCfeEnEspera as SELECT 1 as t');
go

alter view ucfe.vwCfeEnEspera as
--Prop�sito. Lista los comprobantes que se deben enviar a UCFE
--Usado por. 
--Requisitos. Posibles estados:
--		Vac�o. Est� listo para enviar a UCFE
--		CFE_LISTO. Est� listo para enviar a UCFE
--27/03/18 jcf Creaci�n cfe Uruguay
--

	select  tv.tipoCfe, tv.codTerminal, tv.codComercio, tv.sopnumbe, tv.SOPTYPE, tv.docid
	from ucfe.vwComprobantesFiscalesElectronicos tv
	where isnull(tv.usrtab01, '') in ('CFE_ENESPERA', 'DGI2_ENESPERA')

go

IF (@@Error = 0) PRINT 'Creaci�n exitosa de la vista: vwCfeEnEspera'
ELSE PRINT 'Error en la creaci�n de la vista: vwCfeEnEspera'
GO
