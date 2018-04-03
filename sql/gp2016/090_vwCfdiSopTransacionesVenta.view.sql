IF (OBJECT_ID ('ucfe.vwCfdiSopTransaccionesVenta', 'V') IS NULL)
   exec('create view ucfe.vwCfdiSopTransaccionesVenta as SELECT 1 as t');
go

alter view ucfe.vwCfdiSopTransaccionesVenta
--Propósito. Obtiene las transacciones de venta SOP. 
--Utiliza:	vwRmTransaccionesTodas
--Requisitos. No muestra facturas registradas en cuentas por cobrar. 
--26/03/18 jcf Creación cfe Uruguay
--
AS

SELECT	'contabilizado' estadoContabilizado,
		case when rmx.TXRGNNUM = '' 
			then rtrim(ucfe.fCfdReemplazaCaracteresNI(replace(cab.custnmbr, '-', '')))
			else rtrim(ucfe.fCfdReemplazaCaracteresNI(rtrim(left(replace(rmx.TXRGNNUM, '-', ''), 23))))	--loc argentina usa los 23 caracteres de la izquierda
		end idImpuestoCliente,
		ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(rmx.TXRGNNUM), 10) TXRGNNUM,
		ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(rmx.TAXEXMT2), 10) TAXEXMT2,
		rmx.CCode,
		cab.CUSTNMBR,
		ucfe.fCfdReemplazaSecuenciaDeEspacios(ltrim(rtrim(ucfe.fCfdReemplazaCaracteresNI(cab.CUSTNAME))), 10)	nombreCliente,
		rtrim(cab.docid) docid, cab.SOPTYPE, 
		rtrim(cab.sopnumbe) sopnumbe, 
		cab.docdate, 
		CONVERT(datetime, 
				replace(convert(varchar(20), cab.DOCDATE, 102), '.', '-')+'T'+
				case when substring(cab.DOCNCORR, 3, 1) = ':' then rtrim(LEFT(cab.docncorr, 8)) 
				else '00:00:00' end,
				126) fechaHora,
		cab.ORDOCAMT total,		
		cab.ORSUBTOT + cab.ORMRKDAM subtotal, 
		cab.ORTAXAMT impuesto, cab.ORMRKDAM, cab.ORTDISAM, cab.ORMRKDAM + cab.ORTDISAM descuento, 
		cab.orpmtrvd, rtrim(mo.isocurrc) curncyid, 
		case when cab.xchgrate <= 0 then 1 else cab.xchgrate end xchgrate, 
		cab.voidStts + isnull(rmx.voidstts, 0) voidstts, rmx.montoActualOriginal,
		ucfe.fCfdEsVacio(ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(cab.address1), 10)) address1, 
		ucfe.fCfdEsVacio(ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(cab.address2), 10)) address2, 
		ucfe.fCfdEsVacio(ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(cab.address3), 10)) address3, 
		ucfe.fCfdEsVacio(ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(cab.city), 10)) city, 
		ucfe.fCfdEsVacio(ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(cab.[STATE]), 10)) [state], 
		ucfe.fCfdEsVacio(ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(cab.country), 10)) country, 
		right('00000'+ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(cab.zipcode), 10), 5) zipcode, 
		cab.duedate, cab.pymtrmid, cab.glpostdt, 
		ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(cab.cstponbr), 10) cstponbr,
		da.USRDEF05, isnull(da.usrtab01, '') usrtab01, cab.commntid, isnull(da.comment_1, '') comment_1,
		da.serieCfeRef, da.nroCfeRef, da.USERDEF1, cab.dex_row_id
  from	sop30200 cab							--sop_hdr_hist
		left outer join dbo.vwRmTransaccionesTodas rmx
             ON rmx.RMDTYPAL in (1, 8)			-- 1 invoice, 8 return
            and rmx.bchsourc = 'Sales Entry'	-- incluye sop
            and (cab.sopType-2 = rmx.rmdTypAl or cab.sopType+4 = rmx.rmdTypAl) --elimina la posibilidad de repetidos
            and cab.sopnumbe = rmx.DOCNUMBR
		OUTER APPLY ucfe.fCfdiDatosAdicionales(cab.soptype, cab.sopnumbe) da
		left outer join dynamics..mc40200 mo
			on mo.CURNCYID = cab.curncyid
 where cab.soptype in (3, 4)					--3 invoice, 4 return
 union all
 select 'en lote' estadoContabilizado, cab.custnmbr idImpuestoCliente, cab.custnmbr, '' TAXEXMT2, 
		cab.CCode, cab.CUSTNMBR, cab.CUSTNAME nombreCliente,
		rtrim(cab.docid) docid, cab.SOPTYPE, rtrim(cab.sopnumbe) sopnumbe, 
		cab.docdate, cab.docdate fechaHora,
		cab.ORDOCAMT total, cab.ORSUBTOT subtotal, cab.ORTAXAMT impuesto, 0, cab.ORTDISAM, cab.ORTDISAM descuento, 
		cab.orpmtrvd, rtrim(cab.curncyid) curncyid, 
		cab.xchgrate, 
		cab.voidStts, cab.ORDOCAMT, 
		cab.address1, cab.address2, cab.address3, cab.city, cab.[STATE], cab.country, cab.zipcode, 
		cab.duedate, cab.pymtrmid, cab.glpostdt, 
		cab.cstponbr,
		ctrl.USRDEF05, ctrl.usrtab01, cab.commntid, ctrl.comment_1,
		ctrl.serieCfeRef, ctrl.nroCfeRef, ctrl.USERDEF1, cab.dex_row_id
 from  SOP10100 cab								--sop_hdr_work
		OUTER APPLY ucfe.fCfdiDatosAdicionales(cab.soptype, cab.sopnumbe) ctrl
 where cab.SOPTYPE in (3, 4)					--3 invoice, 4 return
go

IF (@@Error = 0) PRINT 'Creación exitosa de: vwCfdiSopTransaccionesVenta'
ELSE PRINT 'Error en la creación de: vwCfdiSopTransaccionesVenta'
GO

-------------------------------------------------------------------------------------------------------
--select isocurrc, curncyid, *
--from dynamics..mc40200
--use dynamics;
