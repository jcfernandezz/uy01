
-----------------------------------------------------------------------------------------
IF (OBJECT_ID ('ucfe.vwRespuestasDeBandejaOutUcfe_PROD', 'V') IS NULL)
   exec('create view ucfe.vwRespuestasDeBandejaOutUcfe_PROD as SELECT 1 as t');
go

alter view ucfe.vwRespuestasDeBandejaOutUcfe_PROD as
--Propósito. Obtiene las respuesta de la bandeja de salida de ucfe
--Usado por. 
--Requisitos. Revisar posibles respuestas en pg 80 de Manual de integración ucfe
--27/03/18 jcf Creación cfe Uruguay

select dco.UUID, dco.IdReq, dco.CodRta, dco.MensajeRta, 
	CASE when dco.CodRta = '00' then 'DGI2_ACEPTA'
		 when dco.CodRta = '11' then 'DGI1_ACEPTA'
		 when dco.CodRta in ('01', '05') then 'DGI2_RECHAZA'
		 when dco.CodRta in ('03', '89', '30', '31', '96') then 'UCFE_ERROR'
		 ELSE 'CODIGO RTA DESCONOCIDO'
	END siguienteStatusCfe,
	dco.Serie, dco.NumeroCfe, isnull(dco.Serie, '') +'-'+ isnull(convert(varchar(10), dco.NumeroCfe), '') serieNumeroCfe, 
	dco.Xml, dco.TipoMsj
FROM ucfeClienteInterProd..DatabaseChannelOutput dco
inner join (
		SELECT bs.UUID, max(bs.IdReq) idreq
		FROM ucfeClienteInterProd..DatabaseChannelOutput bs
		inner join ucfe.vwCfeEnEspera cee
		on bs.UUID = cee.sopnumbe
		group by bs.UUID
	) ultimoReq
	on dco.IdReq = ultimoReq.idreq
go

IF (@@Error = 0) PRINT 'Creación exitosa de la vista: vwRespuestasDeBandejaOutUcfe_PROD'
ELSE PRINT 'Error en la creación de la vista: vwRespuestasDeBandejaOutUcfe_PROD'
GO
