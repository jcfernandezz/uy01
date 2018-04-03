
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = 'ucfe'
     AND SPECIFIC_NAME = 'spConsultaEstadoCFEABandejaUCFE_PROD' 
)
   DROP PROCEDURE ucfe.spConsultaEstadoCFEABandejaUCFE_PROD;
GO
------------------------------------------------------------------------------------------------------
--Propósito. Consulta el estado de un CFE. El tipo de mensaje es 360. Pg82
--Requisito. 
--29/03/18 jcf Creación
--
create PROCEDURE ucfe.spConsultaEstadoCFEABandejaUCFE_PROD 
AS
	BEGIN TRY
		BEGIN TRAN;
		insert into ucfeClienteInterProd..DatabaseChannelInput(TipoMsj, TipoCfe, CodTerminal, CodComercio, FechaReq, HoraReq, UUID)
		select 360, pe.tipoCfe, pe.codTerminal, pe.codComercio, GETDATE(), 0, pe.sopnumbe
		from ucfe.vwCfeDgi1Acepta pe;

		MERGE sop10106 AS T
		USING (select sopnumbe, soptype, siguienteStatusCfe from ucfe.vwCfeDgi1Acepta) AS S
		ON (T.sopnumbe = S.sopnumbe
			and T.soptype = S.soptype)
		WHEN MATCHED 
			THEN UPDATE SET T.usrtab01 = S.siguienteStatusCfe
		WHEN NOT MATCHED BY TARGET 
			THEN INSERT(SOPTYPE, SOPNUMBE, USRTAB01, CMMTTEXT) VALUES(S.SOPTYPE, S.SOPNUMBE, S.siguienteStatusCfe, '');
		--OUTPUT $action, inserted.*, deleted.*;

		COMMIT TRAN;
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

IF (@@Error = 0) PRINT 'Creación exitosa de: spConsultaEstadoCFEABandejaUCFE_PROD'
ELSE PRINT 'Error en la creación de: spConsultaEstadoCFEABandejaUCFE_PROD'
GO

----------------------------------------------------------------------------------------------------
