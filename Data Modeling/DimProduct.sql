-- Create schema if it does not exist
IF SCHEMA_ID('raw') IS NULL
    EXEC('CREATE SCHEMA raw;');
GO

-- Drop the existing table
IF OBJECT_ID('raw.ProductInfo', 'U') IS NOT NULL
    DROP TABLE raw.ProductInfo;

CREATE TABLE raw.ProductInfo (
    ProductId   INT NOT NULL,
    ProductName VARCHAR(50) NOT NULL,
    Category    VARCHAR(100),
    SubCategory VARCHAR(30) NOT NULL,
    Brand       VARCHAR(50),
    CONSTRAINT Product_pk PRIMARY KEY (ProductId)
);

-- Remove duplicates, then insert products with generated IDs
WITH Products AS (
    SELECT DISTINCT
        ProductName,
        Category,
        SubCategory,
        Brand
    FROM dbo.SalesFlat
)
INSERT INTO raw.ProductInfo (
    ProductId,
    ProductName,
    Category,
    SubCategory,
    Brand
)
SELECT
    ROW_NUMBER() OVER (
        ORDER BY ProductName, Category, SubCategory, Brand
    ),
    ProductName,
    Category,
    SubCategory,
    Brand
FROM Products;