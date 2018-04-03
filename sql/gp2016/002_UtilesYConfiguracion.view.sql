-------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('ucfe.fCfdReemplazaSecuenciaDeEspacios') IS NOT NULL
   DROP FUNCTION ucfe.fCfdReemplazaSecuenciaDeEspacios
GO

create function ucfe.fCfdReemplazaSecuenciaDeEspacios(@texto nvarchar(max), @repeticiones smallint)
returns NVARCHAR(MAX)
--Propósito. Reemplaza toda secuencia de espacios en un texto por un único espacio
--10/05/12 jcf Creación (Michael Meierruth)
--
begin
	RETURN   replace(replace(replace(replace(replace(replace(replace(ltrim(rtrim(@texto)),
	  '                                 ',' '),
	  '                 ',' '),
	  '         ',' '),
	  '     ',' '),
	  '   ',' '),
	  '  ',' '),
	  '  ',' ')

--Jeff Moden
--REPLACE(
--            REPLACE(
--                REPLACE(
--                    LTRIM(RTRIM(@texto))
--                ,'  ',' '+CHAR(8))  --Changes 2 spaces to the OX model
--            ,CHAR(8)+' ','')        --Changes the XO model to nothing
--        ,CHAR(8),'') AS CleanString --Changes the remaining X's to nothing

end
go
IF (@@Error = 0) PRINT 'Creación exitosa de: fCfdReemplazaSecuenciaDeEspacios()'
ELSE PRINT 'Error en la creación de: fCfdReemplazaSecuenciaDeEspacios()'
GO
-------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('ucfe.fCfdReemplazaCaracteresNI') IS NOT NULL
   DROP FUNCTION ucfe.fCfdReemplazaCaracteresNI
GO

create function ucfe.fCfdReemplazaCaracteresNI(@texto nvarchar(max))
returns NVARCHAR(MAX)
--Propósito. Reemplaza caracteres no imprimibles por espacios
--26/10/10 jcf Creación
--
as
begin
	declare @textoModificado nvarchar(max)
	select @textoModificado = @texto
	select @textoModificado = replace(@textoModificado, char(13), ' ')
	select @textoModificado = replace(@textoModificado, char(10), ' ')
	select @textoModificado = replace(@textoModificado, char(9), ' ')
	select @textoModificado = replace(@textoModificado, '|', '')
	return @textoModificado 
end
go
IF (@@Error = 0) PRINT 'Creación exitosa de: fCfdReemplazaCaracteresNI()'
ELSE PRINT 'Error en la creación de: fCfdReemplazaCaracteresNI()'
GO


-----------------------------------------------------------------------------------------
--IF OBJECT_ID ('ucfe.fCfdObtienePorcentajeImpuesto') IS NOT NULL
--   DROP FUNCTION ucfe.fCfdObtienePorcentajeImpuesto
--GO

--create FUNCTION ucfe.fCfdObtienePorcentajeImpuesto (@p_idimpuesto varchar(20))
--RETURNS numeric(19,2)
--AS
--BEGIN
--   DECLARE @l_TXDTLPCT numeric(19,5)
--   select @l_TXDTLPCT = TXDTLPCT from tx00201 where taxdtlid = @p_idimpuesto
--   RETURN(@l_TXDTLPCT)
--END
--go

--IF (@@Error = 0) PRINT 'Creación exitosa de: fCfdObtienePorcentajeImpuesto()'
--ELSE PRINT 'Error en la creación de: fCfdObtienePorcentajeImpuesto()'
--GO
-------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('ucfe.fCfdReemplazaEspecialesXml') IS NOT NULL
   DROP FUNCTION ucfe.fCfdReemplazaEspecialesXml
GO

create function ucfe.fCfdReemplazaEspecialesXml(@texto nvarchar(max))
returns NVARCHAR(MAX)
--Propósito. Reemplaza caracteres especiales xml por caracteres ascii. 
--			Al convertir una cadena usando for xml, automáticamente convierte los caracteres especiales. Por eso se deben volver a convertir a ascii.
--26/10/10 jcf Creación
--
as
begin
	declare @textoModificado nvarchar(max)
	select @textoModificado = @texto
	select @textoModificado = replace(@textoModificado, '&amp;', '&')
	select @textoModificado = replace(@textoModificado, '&lt;', '<')
	select @textoModificado = replace(@textoModificado, '&gt;', '>')
	select @textoModificado = replace(@textoModificado, '&quot;', '"')
	select @textoModificado = replace(@textoModificado, '&#39;', '?')
	--select @textoModificado = replace(@textoModificado, '''', '&apos;')
	
	return @textoModificado 
end
go
IF (@@Error = 0) PRINT 'Creación exitosa de: fCfdReemplazaEspecialesXml()'
ELSE PRINT 'Error en la creación de: fCfdReemplazaEspecialesXml()'
GO
-------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('ucfe.fCfdEsVacio') IS NOT NULL
   DROP FUNCTION ucfe.fCfdEsVacio
GO

create function ucfe.fCfdEsVacio(@texto nvarchar(max))
returns NVARCHAR(MAX)
--Propósito. Devuelve un caracter si el texto es vacío 
--10/03/11 jcf Creación
--
as
begin
	if @texto = ''
		return '-'

	return @texto
end
go
IF (@@Error = 0) PRINT 'Creación exitosa de: fCfdEsVacio()'
ELSE PRINT 'Error en la creación de: fCfdEsVacio()'
GO
--------------------------------------------------------------------------------------------------------

