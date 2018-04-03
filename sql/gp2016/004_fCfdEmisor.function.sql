
IF OBJECT_ID ('ucfe.fCfdiEmisor') IS NOT NULL
   DROP FUNCTION ucfe.fCfdiEmisor
GO

create function ucfe.fCfdiEmisor()
returns table
as
--Propósito. Devuelve datos del emisor
--Requisitos. 
--Utilizado por. 
--04/12/17 jcf Creación cfdi
--
return
( 
select rtrim(ci.TAXREGTN) TAXREGTN, 
	ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(RTRIM(ci.CMPNYNAM)), 10) CMPNYNAM, 
	ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(RTRIM(ci.LOCATNNM)), 10) LOCATNNM, 
	ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(RTRIM(ci.ADRCNTCT)), 10) ADRCNTCT, 
	ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(rtrim(ci.ADDRESS1)), 10) ADDRESS1, 
	ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(rtrim(ci.ADDRESS2)), 10) ADDRESS2, 
	ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(RTRIM(ci.CITY)), 10) CITY, 
	ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(RTRIM(ci.COUNTY)), 10) COUNTY, 
	ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(RTRIM(ci.[STATE])), 10) [STATE],  
	ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(RTRIM(ci.CMPCNTRY)), 10) CMPCNTRY, 
	ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(RTRIM(ci.ZIPCODE)), 10) ZIPCODE, 
	left(ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(
			rtrim(ci.ADDRESS1)+' '+rtrim(ci.ADDRESS2)+' '+RTRIM(ci.ZIPCODE)+' '+RTRIM(ci.COUNTY)+' '+RTRIM(ci.CITY)+' '+RTRIM(ci.[STATE])+' '+RTRIM(ci.CMPCNTRY)), 10), 250) LugarExpedicion,
	nt.param1 [version], 
	ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(ISNULL(nt.INET7, '')), 10) INET7,
	ucfe.fCfdReemplazaSecuenciaDeEspacios(ucfe.fCfdReemplazaCaracteresNI(ISNULL(nt.INET8, '')), 10) INET8,
	nt.param2 timeZone,
	nt.param3 sucursal,
	nt.param4 incluyeAddendaDflt
from DYNAMICS..SY01500 ci			--sy_company_mstr
cross apply ucfe.fCfdiParametros('VERSION', 'NA', 'SUCURSAL', 'NA', 'NA', 'NA', ci.LOCATNID) nt
where ci.INTERID = DB_NAME()
)
go

IF (@@Error = 0) PRINT 'Creación exitosa de la función: fCfdiEmisor()'
ELSE PRINT 'Error en la creación de la función: fCfdiEmisor()'
GO

------------------------------------------------------------------------------------
--select *
--from ucfe.fCfdiEmisor()

