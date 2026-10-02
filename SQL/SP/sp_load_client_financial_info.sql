
CREATE OR ALTER PROCEDURE dbo.sp_load_client_financial_info
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.client_financial_info (
        customer_id,
        credit_score,
        estimated_salary,
        balance
    )
    SELECT
        customer_id,
        credit_score,
        estimated_salary,
        balance
    FROM dbo.stg_bank_customer_churn;
END;
GO