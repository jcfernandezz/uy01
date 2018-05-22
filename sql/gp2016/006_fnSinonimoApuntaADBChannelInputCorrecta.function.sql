
IF OBJECT_ID ('ucfe.fnSinonimoApuntaADBChannelInputCorrecta') IS NOT NULL
   DROP FUNCTION ucfe.fnSinonimoApuntaADBChannelInputCorrecta
GO
--Propósito. Verifica que el sinónimo de ChannelInput apunte a la bd correcta: test o prod
--19/04/18 jcf Creación
--
create function ucfe.fnSinonimoApuntaADBChannelInputCorrecta()
returns table
AS
	return (
		SELECT s.base_object_name , p.bd_ucfe
		FROM sys.synonyms s
			cross apply (select case when param1 = db_name() then param3
									when param2 = db_name() then param4
									else 'bd_no_existe'
								end bd_ucfe
						from ucfe.fCfdiParametros('BD_GPPROD', 'BD_GPTEST', 'BD_UCFEPROD', 'BD_UCFETEST', 'NA', 'NA', 'UCFE')
						) p
		where  base_object_name like '%'+p.bd_ucfe+'%DatabaseChannelInput%'
		)


GO

IF (@@Error = 0) PRINT 'Creación exitosa de: fnSinonimoApuntaADBChannelInputCorrecta'
ELSE PRINT 'Error en la creación de: fnSinonimoApuntaADBChannelInputCorrecta'
GO

----------------------------------------------------------------------------------------------------
-- =============================================
--select *
--from ucfe.fnSinonimoApuntaADBChannelInputCorrecta()
