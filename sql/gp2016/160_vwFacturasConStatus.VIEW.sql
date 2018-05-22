-----------------------------------------------------------------------------------------
IF (OBJECT_ID ('dbo.vwUcfeFacturasConStatus', 'V') IS NULL)
   exec('create view dbo.vwUcfeFacturasConStatus as SELECT 1 as t');
go

alter view dbo.vwUcfeFacturasConStatus as
--Propósito. Lista los comprobantes de factura electrónica con su status ucfe
--Usado por. 
--Requisitos. 
--18/04/18 jcf Creación cfe Uruguay
--

 select tv.tipoCfe, tv.sopnumbe, tv.SOPTYPE, tv.docid, 
  tv.statusCfe, isnull(tv.USRDEF05, '') serieNumCfe,
  isnull(um.IdReq, 0) IdReq, isnull(um.CodRta, '') CodRta, isnull(um.MensajeRta, '') MensajeRta, --isnull(vnc.validacionGP, '') validacionGP, 
  isnull(um.[Xml], '') ucfeXml, isnull(um.TipoMsj, '') TipoMsj, convert(varchar(35), isnull(um.FechaHoraRta, 0)) FechaHoraRta
 from ucfe.vwComprobantesFiscalesElectronicos tv
  left join ucfe.vwUltimoMensajeDeUcfeClienteInter um
   on um.UUID = tv.sopnumbe
--  outer apply ucfe.fnValidaNCAplicada(tv.soptype, tv.docXml) vnc

go

IF (@@Error = 0) PRINT 'Creación exitosa de la vista: vwUcfeFacturasConStatus'
ELSE PRINT 'Error en la creación de la vista: vwUcfeFacturasConStatus'
GO
