
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = 'ucfe'
     AND SPECIFIC_NAME = 'spSolicitaFirmaABandejaUCFE' 
)
   DROP PROCEDURE ucfe.spSolicitaFirmaABandejaUCFE;
GO
------------------------------------------------------------------------------------------------------
--Propósito. Solicita firma de CFE
--Requisito. 
--19/04/18 jcf Creación
--17/05/18 jcf Agrega adenda
--
create PROCEDURE ucfe.spSolicitaFirmaABandejaUCFE 
AS
	BEGIN TRY
		if exists(select * from ucfe.fnSinonimoApuntaADBChannelInputCorrecta())
		begin
			BEGIN TRAN;
			insert into ucfe.synonymDatabaseChannelInput(TipoMsj, TipoCfe, CodTerminal, CodComercio, FechaReq, HoraReq, UUID, adenda, [Xml])
										select 310, pe.tipoCfe, pe.codTerminal, pe.codComercio, GETDATE(), 0, pe.sopnumbe, 
											'Condición de pago: '+rtrim(pe.pymtrmid)+char(10)+case when pe.soptype = 3 then 'Incoterm: ' else '' end + rtrim(pe.comment_1), 
											convert(varchar(max), pe.docXml)
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

IF (@@Error = 0) PRINT 'Creación exitosa de: spSolicitaFirmaABandejaUCFE'
ELSE PRINT 'Error en la creación de: spSolicitaFirmaABandejaUCFE'
GO

----------------------------------------------------------------------------------------------------
