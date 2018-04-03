--------------------------------------------------------------------------------------------------------

IF OBJECT_ID ('ucfe.fCfdiDatosAdicionales') IS NOT NULL
   DROP FUNCTION ucfe.fCfdiDatosAdicionales
GO

create function ucfe.fCfdiDatosAdicionales(@soptype smallint, @sopnumbe varchar(21))
returns table
as
--Propósito. Devuelve datos adicionales de la factura
--Requisitos. -
--24/10/17 jcf Creación cfdi
--
return
( 
	select ctrl.USRDEF05, ctrl.usrtab01, ctrl.comment_1, CTRL.USERDEF1,
		rtrim(substring(ctrl.USRDEF05, 0, patindex('%-%', ctrl.USRDEF05))) serieCfeRef,
		rtrim(substring(ctrl.USRDEF05, patindex('%-%', ctrl.USRDEF05)+1, 7)) nroCfeRef
	from SOP10106 ctrl					--campos def. por el usuario.
	where ctrl.soptype = @soptype
	and ctrl.sopnumbe = @sopnumbe
)
go

IF (@@Error = 0) PRINT 'Creación exitosa de la función: fCfdiDatosAdicionales()'
ELSE PRINT 'Error en la creación de la función: fCfdiDatosAdicionales()'
GO
--------------------------------------------------------------------------------------------------------

--select		substring(ctrl.USRDEF05, 0, patindex('%-%', ctrl.USRDEF05)) serieCfeRef,
--		substring(ctrl.USRDEF05, patindex('%-%', ctrl.USRDEF05)+1, 7) nroCfeRef
--from 
--	(select '3-1666 . ' USRDEF05
--	) ctrl

