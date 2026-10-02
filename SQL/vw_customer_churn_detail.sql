CREATE OR ALTER VIEW dbo.vw_customer_churn_detail
AS
SELECT
    p.customer_id,
    p.country,
    p.gender,
    p.age,
    g.generation_name AS generation,
    f.credit_score,
    f.estimated_salary,
    f.balance,
    r.tenure,
    r.products_number,
    r.credit_card,
    r.active_member,
    c.churn
FROM dbo.client_personal_info p
LEFT JOIN dbo.generations_catalog g
    ON p.generation_id = g.generation_id
INNER JOIN dbo.client_financial_info f
    ON p.customer_id = f.customer_id
INNER JOIN dbo.client_bank_relationship r
    ON p.customer_id = r.customer_id
INNER JOIN dbo.client_churn c
    ON p.customer_id = c.customer_id;