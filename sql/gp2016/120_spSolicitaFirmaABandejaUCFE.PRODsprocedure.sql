
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = 'ucfe'
     AND SPECIFIC_NAME = 'spSolicitaFirmaABandejaUCFE_PROD' 
)
   DROP PROCEDURE ucfe.spSolicitaFirmaABandejaUCFE_PROD;
GO
------------------------------------------------------------------------------------------------------
--Propósito. Solicita firma de CFE
--Requisito. 
--28/03/18 jcf Creación
--
create PROCEDURE ucfe.spSolicitaFirmaABandejaUCFE_PROD 
AS
	BEGIN TRY
		BEGIN TRAN;
		insert into ucfeClienteInterProd..DatabaseChannelInput(TipoMsj, TipoCfe, CodTerminal, CodComercio, FechaReq, HoraReq, UUID, [Xml])
		select 310, pe.tipoCfe, pe.codTerminal, pe.codComercio, GETDATE(), 0, pe.sopnumbe, convert(varchar(max), pe.docXml)
		from ucfe.vwCfePendientesDeEnviar pe
		;

		MERGE sop10106 AS T
		USING (select sopnumbe, soptype, siguienteStatusCfe from ucfe.vwCfePendientesDeEnviar) AS S
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

IF (@@Error = 0) PRINT 'Creación exitosa de: spSolicitaFirmaABandejaUCFE_PROD'
ELSE PRINT 'Error en la creación de: spSolicitaFirmaABandejaUCFE_PROD'
GO

----------------------------------------------------------------------------------------------------
