use UCFEClienteInterProd;
go

create user [id usuario] for login [id usuario];
EXEC sp_addrolemember 'rol_uruguayUcfe', 'id usuario' ;
go