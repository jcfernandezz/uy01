--WINTERS Uruguay
--Factura Electrónica
--Propósito. Accesos a objetos de NAVIGATION LIST BUILDER de factura electrónica
--Requisitos. Ejecutar antes los permisos para factura electrónica 
-------------------------------------------------------------------------------------------
--Permiso a usuarios sql
-------------------------------------------------------------------------------------------
use UCFEClienteInterProd	--UCFEClienteInterTest; --
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


create user aaparicio for login aaparicio;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'aaparicio' ;

create user adrianau for login adrianau;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'adrianau' ;

create user adrianom for login adrianom;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'adrianom' ;

create user aiezzi for login aiezzi;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'aiezzi' ;

create user alicia for login alicia;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'alicia' ;

create user amarcon for login amarcon;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'amarcon' ;

create user arieli for login arieli;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'arieli' ;

create user aurquiola for login aurquiola;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'aurquiola' ;

create user cgava for login cgava;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'cgava' ;

create user comex for login comex;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'comex' ;

create user danielar for login danielar;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'danielar' ;

create user drodriguez for login drodriguez;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'drodriguez' ;

create user dvillegas for login dvillegas;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'dvillegas' ;

create user earra for login earra;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'earra' ;

create user electronica for login electronica;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'electronica' ;

create user factura for login factura;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'factura' ;

create user facturacion for login facturacion;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'facturacion' ;

create user falvarez for login falvarez;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'falvarez' ;

create user fdonadio for login fdonadio;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'fdonadio' ;

create user flongo for login flongo;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'flongo' ;

create user freddy for login freddy;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'freddy' ;

create user fvanni for login fvanni;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'fvanni' ;

create user fvanni_ventas for login fvanni_ventas;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'fvanni_ventas' ;

create user ggonzalez for login ggonzalez;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'ggonzalez' ;

create user jlesnik for login jlesnik;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'jlesnik' ;

create user juant for login juant;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'juant' ;

create user latam for login latam;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'latam' ;

create user logistica for login logistica;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'logistica' ;

create user logistica1 for login logistica1;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'logistica1' ;

create user lpolit for login lpolit;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'lpolit' ;

create user marianor for login marianor;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'marianor' ;

create user monicar for login monicar;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'monicar' ;

create user mregis for login mregis;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'mregis' ;

create user mromolo for login mromolo;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'mromolo' ;

create user nsaliwonczyk for login nsaliwonczyk;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'nsaliwonczyk' ;

create user patriciab for login patriciab;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'patriciab' ;

create user pblanco for login pblanco;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'pblanco' ;

create user pzerda for login pzerda;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'pzerda' ;

create user rominas for login rominas;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'rominas' ;

create user rosam for login rosam;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'rosam' ;

create user rsosa for login rsosa;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'rsosa' ;

create user smardigian for login smardigian;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'smardigian' ;

create user sofiac for login sofiac;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'sofiac' ;

create user sofiam for login sofiam;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'sofiam' ;

create user umichalek for login umichalek;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'umichalek' ;

create user vanesab for login vanesab;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'vanesab' ;

create user vbritez for login vbritez;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'vbritez' ;

create user venta2 for login venta2;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'venta2' ;

create user ventas2 for login ventas2;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'ventas2' ;

create user [ventas-elec] for login [ventas-elec];
EXEC sp_addrolemember 'rol_uruguayUcfe', 'ventas-elec' ;

create user vfrizone for login vfrizone;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'vfrizone' ;

create user wbd for login wbd;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'wbd' ;

create user winla for login winla;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'winla' ;

create user winla16 for login winla16;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'winla16' ;

create user yrobatto for login yrobatto;
EXEC sp_addrolemember 'rol_uruguayUcfe', 'yrobatto' ;


go
