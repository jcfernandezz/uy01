--WINTERS
--Factura Electrónica
--Propósito. Accesos a objetos de NAVIGATION LIST BUILDER de factura electrónica
--Requisitos. Ejecutar antes los permisos para factura electrónica 
-------------------------------------------------------------------------------------------
--Permiso a usuarios sql
-------------------------------------------------------------------------------------------
use UCFEClienteInterTest; --UCFEClienteInterProd
go

create user [jcf] for login [jcf];
create user [mig] for login [mig];
create user [abalbis] for login [abalbis];
create user [rmonteverde] for login [rmonteverde];

EXEC sp_addrolemember 'rol_uruguayUcfe', 'jcf' ;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'mig' ;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'abalbis' ;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'rmonteverde' ;

go
