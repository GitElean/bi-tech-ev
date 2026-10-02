CREATE OR ALTER PROCEDURE dbo.sp_load_client_churn
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.client_churn (
        customer_id,
        churn
    )
    SELECT
        customer_id,
        CONVERT(
            BIT,
            TRIM(REPLACE(churn, CHAR(13), ''))
        )
    FROM dbo.stg_bank_customer_churn;
END;
GO
