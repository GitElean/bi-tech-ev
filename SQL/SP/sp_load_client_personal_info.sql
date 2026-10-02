
CREATE OR ALTER PROCEDURE dbo.sp_load_client_personal_info
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @current_year INT = YEAR(GETDATE());

    INSERT INTO dbo.client_personal_info (
        customer_id,
        country,
        gender,
        age,
        generation_id
    )
    SELECT
        s.customer_id,
        TRIM(s.country),
        TRIM(s.gender),
        s.age,
        g.generation_id
    FROM dbo.stg_bank_customer_churn s
    LEFT JOIN dbo.generations_catalog g
        ON (@current_year - s.age)
        BETWEEN g.min_birth_year AND g.max_birth_year;
END;
GO