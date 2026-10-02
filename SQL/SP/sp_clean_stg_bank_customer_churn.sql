
--Sp de limpieza de datos
CREATE OR ALTER PROCEDURE dbo.sp_clean_stg_bank_customer_churn
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.stg_bank_customer_churn
    SET
        country = NULLIF(TRIM(REPLACE(country, CHAR(13), '')), ''),
        gender = NULLIF(TRIM(REPLACE(gender, CHAR(13), '')), ''),
        credit_card = NULLIF(TRIM(REPLACE(credit_card, CHAR(13), '')), ''),
        active_member = NULLIF(TRIM(REPLACE(active_member, CHAR(13), '')), ''),
        churn = NULLIF(TRIM(REPLACE(churn, CHAR(13), '')), '');

    DELETE FROM dbo.stg_bank_customer_churn
    WHERE customer_id IS NULL;

    WITH duplicated_rows AS (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY customer_id
                ORDER BY customer_id
            ) AS rn
        FROM dbo.stg_bank_customer_churn
    )
    DELETE FROM duplicated_rows
    WHERE rn > 1;
END;
GO

EXEC dbo.sp_clean_stg_bank_customer_churn
GO