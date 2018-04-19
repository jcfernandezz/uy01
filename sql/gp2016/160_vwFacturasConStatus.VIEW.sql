-----------------------------------------------------------------------------------------
IF (OBJECT_ID ('ucfe.vwFacturasConStatus', 'V') IS NULL)
   exec('create view ucfe.vwFacturasConStatus as SELECT 1 as t');
go

alter view ucfe.vwFacturasConStatus as
--Prop�sito. Lista los comprobantes de factura electr�nica con su status ucfe
--Usado por. 
--Requisitos. 
--18/04/18 jcf Creaci�n cfe Uruguay
--

	select tv.tipoCfe, tv.sopnumbe, tv.SOPTYPE, tv.docid, 
		tv.statusCfe, tv.USRDEF05 serieNumCfe,
		um.IdReq, um.CodRta, um.MensajeRta, 
		um.[Xml], um.TipoMsj, um.FechaHoraRta
	from ucfe.vwComprobantesFiscalesElectronicos tv
		left join ucfe.vwUltimoMensajeDeUcfeClienteInter um
			on um.UUID = tv.sopnumbe

go

IF (@@Error = 0) PRINT 'Creaci�n exitosa de la vista: vwFacturasConStatus'
ELSE PRINT 'Error en la creaci�n de la vista: vwFacturasConStatus'
GO
