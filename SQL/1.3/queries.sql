--Distribución de churn por país
SELECT
    country,
    COUNT(*) AS total_clients,
    SUM(CAST(churn AS INT)) AS churned_clients,
    CAST(
        AVG(CAST(churn AS DECIMAL(10,4))) * 100
        AS DECIMAL(10,2)
    ) AS churn_rate
FROM dbo.vw_customer_churn_detail
GROUP BY country
ORDER BY country;

--Análisis de churn por generación (Baby Boomers, X, Millennials y Z)
SELECT
    generation,
    COUNT(*) AS total_clients,
    SUM(CAST(churn AS INT)) AS churned_clients,
    CAST(
        AVG(CAST(churn AS DECIMAL(10,4))) * 100
        AS DECIMAL(10,2)
    ) AS churn_rate
FROM dbo.vw_customer_churn_detail
WHERE generation IN (
    'Baby Boomers',
    'Generation X',
    'Millennials',
    'Generation Z'
)
GROUP BY generation
ORDER BY generation;


--Historial de productos por cliente
SELECT
    customer_id,
    products_number
FROM dbo.vw_customer_churn_detail
ORDER BY customer_id;
-- el data set no tiene info de los productos ni cuando fueron obtenidos, por lo que no se puede sacar un insight significativo

--Conteo de clientes totales, activos, por año de tenure (antigüedad en con el banco)
SELECT
    tenure,
    COUNT(*) AS total_clients,
    SUM(
        CASE
            WHEN active_member = 1 THEN 1
            ELSE 0
        END
    ) AS active_clients
FROM dbo.vw_customer_churn_detail
GROUP BY tenure
ORDER BY tenure;


--Cuántos clientes inactivos tenían tarjeta de crédito
SELECT
    COUNT(*) AS inactive_clients_with_credit_card
FROM dbo.vw_customer_churn_detail
WHERE active_member = 0
  AND credit_card = 1;


--Total, de clientes activos e inactivos por país, género y rango de edad
WITH customer_age_ranges AS (
    SELECT
        country,
        gender,
        active_member,
        CASE
            WHEN age BETWEEN 18 AND 29 THEN '18-29'
            WHEN age BETWEEN 30 AND 39 THEN '30-39'
            WHEN age BETWEEN 40 AND 49 THEN '40-49'
            WHEN age BETWEEN 50 AND 59 THEN '50-59'
            WHEN age >= 60 THEN '60+'
            ELSE 'Other'
        END AS age_range
    FROM dbo.vw_customer_churn_detail
)
SELECT
    country,
    gender,
    age_range,
    SUM(CASE WHEN active_member = 1 THEN 1 ELSE 0 END) AS active_clients,
    SUM(CASE WHEN active_member = 0 THEN 1 ELSE 0 END) AS inactive_clients,
    COUNT(*) AS total_clients
FROM customer_age_ranges
GROUP BY
    country,
    gender,
    age_range
ORDER BY
    country,
    gender,
    age_range;