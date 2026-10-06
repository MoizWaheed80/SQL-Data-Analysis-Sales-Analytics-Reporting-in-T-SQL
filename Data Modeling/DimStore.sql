-- Create schema if it does not exist
IF SCHEMA_ID('raw') IS NULL
    EXEC('CREATE SCHEMA raw;');
GO

-- Drop the existing table
IF OBJECT_ID('raw.StoreInfo', 'U') IS NOT NULL
    DROP TABLE raw.StoreInfo;

CREATE TABLE raw.StoreInfo (
    StoreId       INT NOT NULL,
    StoreName     VARCHAR(50) NOT NULL,
    StoreCity     VARCHAR(100),
    SalesRepName  VARCHAR(30) NOT NULL,
    PaymentMethod VARCHAR(50),
    CONSTRAINT Store_pk PRIMARY KEY (StoreId)
);

-- Remove duplicates, then insert rows with generated IDs
WITH Stores AS (
    SELECT DISTINCT
        StoreName,
        StoreCity,
        SalesRepName,
        PaymentMethod
    FROM dbo.SalesFlat
)
INSERT INTO raw.StoreInfo (
    StoreId,
    StoreName,
    StoreCity,
    SalesRepName,
    PaymentMethod
)
SELECT
    ROW_NUMBER() OVER (
        ORDER BY StoreName, StoreCity, SalesRepName, PaymentMethod
    ),
    StoreName,
    StoreCity,
    SalesRepName,
    PaymentMethod
FROM Stores;