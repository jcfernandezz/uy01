
-----------------------------------------------------------------------------------------
IF (OBJECT_ID ('ucfe.vwRespuestasDeBandejaOutUcfe', 'V') IS NULL)
   exec('create view ucfe.vwRespuestasDeBandejaOutUcfe as SELECT 1 as t');
go

alter view ucfe.vwRespuestasDeBandejaOutUcfe as
--Propósito. Obtiene las respuesta de la bandeja de salida de ucfe de las facturas en espera
--Usado por. 
--Requisitos. Revisar posibles respuestas en pg 80 de Manual de integración ucfe
--19/04/18 jcf Creación cfe Uruguay

select dco.UUID, dco.IdReq, dco.CodRta, dco.MensajeRta, 
	CASE when dco.CodRta = '00' then 'DGI2_ACEPTA'
		 when dco.CodRta = '11' then 'DGI1_ACEPTA'
		 when dco.CodRta in ('01', '05') then 'DGI2_RECHAZA'
		 when dco.CodRta in ('03', '89', '30', '31', '96') then 'UCFE_ERROR'
		 ELSE 'CODIGO RTA DESCONOCIDO'
	END siguienteStatusCfe,
	dco.Serie, dco.NumeroCfe, dco.serieNumeroCfe, 
	dco.Xml, dco.TipoMsj
FROM ucfe.vwUltimoMensajeDeUcfeClienteInter dco
inner join ucfe.vwCfeEnEspera cee
		on dco.UUID = cee.sopnumbe
go

IF (@@Error = 0) PRINT 'Creación exitosa de la vista: vwRespuestasDeBandejaOutUcfe'
ELSE PRINT 'Error en la creación de la vista: vwRespuestasDeBandejaOutUcfe'
GO
