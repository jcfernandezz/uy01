
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = 'ucfe'
     AND SPECIFIC_NAME = 'spConsultaEstadoCFEABandejaUCFE' 
)
   DROP PROCEDURE ucfe.spConsultaEstadoCFEABandejaUCFE;
GO
------------------------------------------------------------------------------------------------------
--Propósito. Consulta el estado de un CFE que obtubieron la primera aceptación de DGI. El tipo de mensaje es 360. Pg82
--Requisito. 
--19/04/18 jcf Creación
--
create PROCEDURE ucfe.spConsultaEstadoCFEABandejaUCFE 
AS
	BEGIN TRY
		if exists(select * from ucfe.fnSinonimoApuntaADBChannelInputCorrecta())
		begin

			BEGIN TRAN;
			insert into ucfe.synonymDatabaseChannelInput(TipoMsj, TipoCfe, CodTerminal, CodComercio, FechaReq, HoraReq, UUID)
			select 360, pe.tipoCfe, pe.codTerminal, pe.codComercio, GETDATE(), 0, pe.sopnumbe
			from ucfe.vwCfeDgi1Acepta pe;

			MERGE sop10106 AS T
			USING (select sopnumbe, soptype, siguienteStatusCfe from ucfe.vwCfeDgi1Acepta) AS S
			ON (T.sopnumbe = S.sopnumbe
				and T.soptype = S.soptype)
			WHEN MATCHED 
				THEN UPDATE SET T.usrtab01 = S.siguienteStatusCfe
			WHEN NOT MATCHED BY TARGET 
				THEN INSERT(SOPTYPE, SOPNUMBE, USRTAB01, CMMTTEXT) VALUES(S.soptype, S.sopnumbe, S.siguienteStatusCfe, '');
			--OUTPUT $action, inserted.*, deleted.*;

			COMMIT TRAN;
		end
	END TRY
	BEGIN CATCH  
		IF @@TRANCOUNT >0    
			ROLLBACK TRAN;
		
		-- Raise an error with the details of the exception
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		SELECT @ErrMsg = ERROR_MESSAGE(),
			 @ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH

GO

IF (@@Error = 0) PRINT 'Creación exitosa de: spConsultaEstadoCFEABandejaUCFE'
ELSE PRINT 'Error en la creación de: spConsultaEstadoCFEABandejaUCFE'
GO

----------------------------------------------------------------------------------------------------
