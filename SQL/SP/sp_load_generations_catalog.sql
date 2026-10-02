--catalogo de generaciones, se usa un ID porqué la forma de escribir las generaciones puede ser muy variable
--aunque el dataset no tenga gen alpha, si el modelo se ejecutará en un par de años ya los incluiría
CREATE OR ALTER PROCEDURE dbo.sp_load_generations_catalog
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @generations TABLE (
        generation_id INT,
        generation_name VARCHAR(50),
        min_birth_year INT,
        max_birth_year INT
    );

    INSERT INTO @generations (
        generation_id,
        generation_name,
        min_birth_year,
        max_birth_year
    )
    VALUES
        (1, 'Silent Generation', 1928, 1945),
        (2, 'Baby Boomers',      1946, 1964),
        (3, 'Generation X',      1965, 1980),
        (4, 'Millennials',       1981, 1996),
        (5, 'Generation Z',      1997, 2010),
        (6, 'Generation Alpha',  2011, 2024);

    UPDATE target
    SET
        target.generation_name = source.generation_name,
        target.min_birth_year = source.min_birth_year,
        target.max_birth_year = source.max_birth_year
    FROM dbo.generations_catalog target
    INNER JOIN @generations source
        ON target.generation_id = source.generation_id;

    INSERT INTO dbo.generations_catalog (
        generation_id,
        generation_name,
        min_birth_year,
        max_birth_year
    )
    SELECT
        source.generation_id,
        source.generation_name,
        source.min_birth_year,
        source.max_birth_year
    FROM @generations source
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.generations_catalog target
        WHERE target.generation_id = source.generation_id
    );
END;
GO