-----------------------------------------------------------------------------------------
IF (OBJECT_ID ('ucfe.vwCfeDgi1Acepta', 'V') IS NULL)
   exec('create view ucfe.vwCfeDgi1Acepta as SELECT 1 as t');
go

alter view ucfe.vwCfeDgi1Acepta as
--Propósito. Lista los comprobantes que se deben enviar a UCFE
--Usado por. 
--Requisitos.
--27/03/18 jcf Creación cfe Uruguay
--

	select  tv.tipoCfe, tv.codTerminal, tv.codComercio, tv.sopnumbe, tv.SOPTYPE, tv.docid, 'DGI2_ENESPERA' siguienteStatusCfe
	from ucfe.vwComprobantesFiscalesElectronicos tv
	where isnull(tv.usrtab01, '') = 'DGI1_ACEPTA';

go

IF (@@Error = 0) PRINT 'Creación exitosa de la vista: vwCfeDgi1Acepta'
ELSE PRINT 'Error en la creación de la vista: vwCfeDgi1Acepta'
GO
