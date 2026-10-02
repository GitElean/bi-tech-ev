
CREATE OR ALTER PROCEDURE dbo.sp_load_client_bank_relationship
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.client_bank_relationship (
        customer_id,
        tenure,
        products_number,
        credit_card,
        active_member
    )
    SELECT
        customer_id,
        tenure,
        products_number,
        CONVERT(
            BIT,
            TRIM(REPLACE(credit_card, CHAR(13), ''))
        ),
        CONVERT(
            BIT,
            TRIM(REPLACE(active_member, CHAR(13), ''))
        )
    FROM dbo.stg_bank_customer_churn;
END;
GO