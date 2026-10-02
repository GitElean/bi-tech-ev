
--SP para cargar la data a la staging

USE ChurnDW;
GO

CREATE OR ALTER PROCEDURE dbo.sp_load_stg_bank_customer_churn
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        TRUNCATE TABLE dbo.stg_bank_customer_churn;

        BULK INSERT dbo.stg_bank_customer_churn
        FROM 'C:\Users\Elean\prubaTECBI\bi-tech-ev\Bank Customer Churn Prediction.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDQUOTE = '"',
            ROWTERMINATOR = '0x0A',
            TABLOCK
        );

        SELECT
            COUNT(*) AS loaded_rows
        FROM dbo.stg_bank_customer_churn;

    END TRY
    BEGIN CATCH

        THROW;

    END CATCH
END;
GO

EXEC dbo.sp_load_stg_bank_customer_churn;
GO