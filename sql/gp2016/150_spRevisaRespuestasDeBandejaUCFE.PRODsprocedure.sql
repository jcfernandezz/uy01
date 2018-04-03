
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = 'ucfe'
     AND SPECIFIC_NAME = 'spRevisaRespuestasDeBandejaUCFE_PROD' 
)
   DROP PROCEDURE ucfe.spRevisaRespuestasDeBandejaUCFE_PROD;
GO
------------------------------------------------------------------------------------------------------
--Prop�sito. Revisa respuestas de UCFE
--Requisito. 
--28/03/18 jcf Creaci�n
--
create PROCEDURE ucfe.spRevisaRespuestasDeBandejaUCFE_PROD 
AS
		MERGE SOP10106 AS T
		USING (select UUID, serieNumeroCfe, CodRta, siguienteStatusCfe 
				from ucfe.vwRespuestasDeBandejaOutUcfe_PROD) as S
		on (T.sopnumbe = S.UUID)
		when MATCHED and S.siguienteStatusCfe != 'CODIGO RTA DESCONOCIDO'
			THEN UPDATE SET T.usrdef05 = S.serieNumeroCfe, T.usrtab01 = S.siguienteStatusCfe
		;

GO

IF (@@Error = 0) PRINT 'Creaci�n exitosa de: spRevisaRespuestasDeBandejaUCFE_PROD'
ELSE PRINT 'Error en la creaci�n de: spRevisaRespuestasDeBandejaUCFE_PROD'
GO

----------------------------------------------------------------------------------------------------
-- =============================================
