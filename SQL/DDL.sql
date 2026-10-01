--DDL para el DW

--TABLA STAGING, aquí entra la info cruda del catálogo (info tipo bronce)

CREATE TABLE dbo.stg_bank_customer_churn (
    customer_id         INT             NULL,
    credit_score        INT             NULL,
    country             VARCHAR(50)     NULL,
    gender              VARCHAR(20)     NULL,
    age                 INT             NULL,
    tenure              INT             NULL,
    balance             DECIMAL(18,2)   NULL,
    products_number     INT             NULL,
    credit_card         VARCHAR(5)      NULL,
    active_member       VARCHAR(5)      NULL,
    estimated_salary    DECIMAL(18,2)   NULL,
    churn               VARCHAR(5)      NULL
);

DROP TABLE dbo.stg_bank_customer_churn

SELECT COUNT(*) FROM dbo.stg_bank_customer_churn

--Tablas de estructura, son las tablas basadas en el esquema snowflake (silver)


CREATE TABLE dbo.generations_catalog (
    generation_id        INT             NOT NULL,
    generation_name      VARCHAR(50)     NOT NULL,
    min_birth_year       INT             NOT NULL,
    max_birth_year       INT             NOT NULL,

    CONSTRAINT PK_generations_catalog
        PRIMARY KEY (generation_id),

    CONSTRAINT UQ_generations_catalog_name
        UNIQUE (generation_name),

    CONSTRAINT CK_generations_catalog_year_range
        CHECK (min_birth_year <= max_birth_year)
);

SELECT * FROM dbo.generations_catalog


----
CREATE TABLE dbo.client_personal_info (
    customer_id         INT             NOT NULL,
    country             VARCHAR(50)     NOT NULL,
    gender              VARCHAR(20)     NOT NULL,
    age                 INT             NOT NULL,
    generation_id       INT             NULL,

    CONSTRAINT PK_client_personal_info
        PRIMARY KEY (customer_id),

    CONSTRAINT FK_client_personal_generation
        FOREIGN KEY (generation_id)
        REFERENCES dbo.generations_catalog(generation_id),

    CONSTRAINT CK_client_personal_age
        CHECK (age >= 0)
);
SELECT * FROM dbo.client_personal_info

-----
CREATE TABLE dbo.client_financial_info (
    customer_id         INT             NOT NULL,
    credit_score        INT             NULL,
    estimated_salary    DECIMAL(18,2)   NULL,
    balance             DECIMAL(18,2)   NULL,

    CONSTRAINT PK_client_financial_info
        PRIMARY KEY (customer_id),

    CONSTRAINT FK_financial_personal
        FOREIGN KEY (customer_id)
        REFERENCES dbo.client_personal_info(customer_id)
);
SELECT * FROM dbo.client_financial_info

----------------------
CREATE TABLE dbo.client_bank_relationship (
    customer_id         INT             NOT NULL,
    tenure              INT             NULL,
    products_number     INT             NULL,
    credit_card         BIT             NULL,
    active_member       BIT             NULL,

    CONSTRAINT PK_client_bank_relationship
        PRIMARY KEY (customer_id),

    CONSTRAINT FK_bank_relationship_personal
        FOREIGN KEY (customer_id)
        REFERENCES dbo.client_personal_info(customer_id),

    CONSTRAINT CK_bank_relationship_tenure
        CHECK (tenure >= 0),

    CONSTRAINT CK_bank_relationship_products
        CHECK (products_number >= 0)
);
SELECT * FROM dbo.client_bank_relationship

--------
CREATE TABLE dbo.client_churn (
    customer_id         INT             NOT NULL,
    churn               BIT             NOT NULL,

    CONSTRAINT PK_client_churn
        PRIMARY KEY (customer_id),

    CONSTRAINT FK_churn_personal
        FOREIGN KEY (customer_id)
        REFERENCES dbo.client_personal_info(customer_id)
);
SELECT * FROM dbo.client_churn