--Ejecutar en las bds de compañia
--
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'ucfe')
BEGIN
EXEC('CREATE SCHEMA ucfe')
END

