
-----------------------------------------------------------------------------------------
IF (OBJECT_ID ('ucfe.vwUltimoMensajeDeUcfeClienteInter', 'V') IS NULL)
   exec('create view ucfe.vwUltimoMensajeDeUcfeClienteInter as SELECT 1 as t');
go

alter view ucfe.vwUltimoMensajeDeUcfeClienteInter as
--Prop�sito. Obtiene la �ltima respuesta de la bandeja de salida de ucfe
--Usado por. 
--Requisitos. Revisar posibles respuestas en pg 80 de Manual de integraci�n ucfe
--18/04/18 jcf Creaci�n cfe Uruguay

select dco.UUID, dco.IdReq, dco.CodRta, dco.MensajeRta, 
	dco.Serie, dco.NumeroCfe, isnull(dco.Serie, '') +'-'+ isnull(convert(varchar(10), dco.NumeroCfe), '') serieNumeroCfe, 
	dco.Xml, dco.TipoMsj, dco.FechaHoraRta
FROM ucfe.synonymDatabaseChannelOutput dco
inner join (
		SELECT bs.UUID, max(bs.IdReq) idreq
		FROM ucfe.synonymDatabaseChannelOutput bs
		group by bs.UUID
	) ultimoReq
	on ultimoReq.UUID = dco.UUID
	and dco.IdReq = ultimoReq.idreq
go

IF (@@Error = 0) PRINT 'Creaci�n exitosa de la vista: vwUltimoMensajeDeUcfeClienteInter'
ELSE PRINT 'Error en la creaci�n de la vista: vwUltimoMensajeDeUcfeClienteInter'
GO
