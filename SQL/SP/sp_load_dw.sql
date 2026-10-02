
--SP de orquestación
CREATE OR ALTER PROCEDURE dbo.sp_load_dw
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.stg_bank_customer_churn
    )
    BEGIN
        THROW 50001, 'La tabla staging no contiene datos para procesar.', 1;
    END;

    BEGIN TRY

        BEGIN TRANSACTION;

        DELETE FROM dbo.client_churn;
        DELETE FROM dbo.client_bank_relationship;
        DELETE FROM dbo.client_financial_info;
        DELETE FROM dbo.client_personal_info;

        EXEC dbo.sp_load_generations_catalog;
        EXEC dbo.sp_load_client_personal_info;
        EXEC dbo.sp_load_client_financial_info;
        EXEC dbo.sp_load_client_bank_relationship;
        EXEC dbo.sp_load_client_churn;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO

EXEC dbo.sp_load_dw
GO