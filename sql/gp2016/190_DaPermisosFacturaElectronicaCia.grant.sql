--Uruguay
--Factura Electrónica
--Propósito. Rol que da accesos a objetos de factura electrónica
--Requisitos. Ejecutar en la compañía.
--2/03/18 JCF Creación
--
-----------------------------------------------------------------------------------
--use arg10

IF DATABASE_PRINCIPAL_ID('rol_uruguayUcfe') IS NULL
	create role rol_uruguayUcfe;

--Objetos que usa factura electrónica
grant execute on ucfe.spSolicitaFirmaABandejaUCFE to rol_uruguayUcfe, dyngrp;
GRANT EXECUTE ON ucfe.spRevisaRespuestasDeBandejaUCFE TO rol_uruguayUcfe, dyngrp;
GRANT EXECUTE ON ucfe.spConsultaEstadoCFEABandejaUCFE TO rol_uruguayUcfe, dyngrp;
grant select on dbo.vwUcfeFacturasConStatus to rol_uruguayUcfe, dyngrp;
grant select on ucfe.vwCfePendientesDeEnviar to rol_uruguayUcfe, dyngrp;
grant select, update, insert, delete on ucfe.synonymDatabaseChannelInput to rol_uruguayUcfe, dyngrp;
grant select, update, insert, delete on dbo.sop10106 to rol_uruguayUcfe, dyngrp;
grant select on ucfe.vwRespuestasDeBandejaOutUcfe to rol_uruguayUcfe, dyngrp;
grant select on ucfe.vwCfeDgi1Acepta to rol_uruguayUcfe, dyngrp;
grant select on ucfe.fnSinonimoApuntaADBChannelInputCorrecta to rol_uruguayUcfe, dyngrp;

GO
USE DYNAMICS;
GO
IF DATABASE_PRINCIPAL_ID('rol_uruguayUcfe') IS NULL
	create role rol_uruguayUcfe;

GRANT SELECT ON mc40200 TO rol_uruguayUcfe, dyngrp;
GRANT SELECT ON SY01500 TO rol_uruguayUcfe, dyngrp;

go
USE ucfeClienteInterTest;
GO
IF DATABASE_PRINCIPAL_ID('rol_uruguayUcfe') IS NULL
	create role rol_uruguayUcfe;

GRANT SELECT, update, delete, insert ON DATABASEChannelInput TO rol_uruguayUcfe;
GRANT SELECT, update, delete, insert ON DATABASEChannelOutput TO rol_uruguayUcfe;

go
USE ucfeClienteInterProd;
GO
IF DATABASE_PRINCIPAL_ID('rol_uruguayUcfe') IS NULL
	create role rol_uruguayUcfe;

GRANT SELECT, update, delete, insert ON DATABASEChannelInput TO rol_uruguayUcfe;
GRANT SELECT, update, delete, insert ON DATABASEChannelOutput TO rol_uruguayUcfe;
go

use master;
GO
IF DATABASE_PRINCIPAL_ID('rol_uruguayUcfe') IS NULL
	create role rol_uruguayUcfe;

GRANT SELECT ON sys.synonyms TO rol_uruguayUcfe;
go

