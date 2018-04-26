
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = 'ucfe'
     AND SPECIFIC_NAME = 'spRevisaRespuestasDeBandejaUCFE' 
)
   DROP PROCEDURE ucfe.spRevisaRespuestasDeBandejaUCFE;
GO
------------------------------------------------------------------------------------------------------
--Prop�sito. Revisa respuestas de UCFE
--Requisito. 
--28/03/18 jcf Creaci�n
--18/04/18 jcf Corrige para cuando la factura tiene un mensaje de error obsoleto. Debe actualizar s�lo los nuevos mensajes
--
create PROCEDURE ucfe.spRevisaRespuestasDeBandejaUCFE 
AS
	if exists(select * from ucfe.fnSinonimoApuntaADBChannelInputCorrecta())
	begin

		MERGE SOP10106 AS T
		USING (select UUID, serieNumeroCfe, CodRta, siguienteStatusCfe, IdReq
				from ucfe.vwRespuestasDeBandejaOutUcfe
				) as S
		on (T.sopnumbe = S.UUID)
		when MATCHED 
			and S.IdReq > convert(int, rtrim(T.usrdef04))	--Si es nuevo mensaje de ucfe
			and S.siguienteStatusCfe != 'CODIGO RTA DESCONOCIDO'
			THEN UPDATE SET T.usrdef05 = S.serieNumeroCfe, T.usrtab01 = S.siguienteStatusCfe, T.usrdef04 = convert(char(20), S.IdReq)
		;
	end
GO

IF (@@Error = 0) PRINT 'Creaci�n exitosa de: spRevisaRespuestasDeBandejaUCFE'
ELSE PRINT 'Error en la creaci�n de: spRevisaRespuestasDeBandejaUCFE'
GO

----------------------------------------------------------------------------------------------------
-- =============================================
