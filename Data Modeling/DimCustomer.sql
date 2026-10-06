-- Create schema if it does not exist
IF SCHEMA_ID('raw') IS NULL
    EXEC('CREATE SCHEMA raw;');
GO

-- Drop the existing table
IF OBJECT_ID('raw.CustomerInfo', 'U') IS NOT NULL
    DROP TABLE raw.CustomerInfo;

CREATE TABLE raw.CustomerInfo (
    CustomerId      INT NOT NULL,
    CustomerName    VARCHAR(50) NOT NULL,
    CustomerEmail   VARCHAR(100),
    CustomerCity    VARCHAR(30) NOT NULL,
    CustomerCountry VARCHAR(50),
    CustomerSegment VARCHAR(30),
    CONSTRAINT customer_pk PRIMARY KEY (CustomerId)
);

-- Remove duplicates, then insert customers with generated IDs
WITH Customers AS (
    SELECT DISTINCT
        CustomerName,
        CustomerEmail,
        CustomerCity,
        CustomerCountry,
        CustomerSegment
    FROM dbo.SalesFlat
)
INSERT INTO raw.CustomerInfo (
    CustomerId,
    CustomerName,
    CustomerEmail,
    CustomerCity,
    CustomerCountry,
    CustomerSegment
)
SELECT
    ROW_NUMBER() OVER (
        ORDER BY CustomerEmail, CustomerName,
                 CustomerCity, CustomerCountry, CustomerSegment
    ),
    CustomerName,
    CustomerEmail,
    CustomerCity,
    CustomerCountry,
    CustomerSegment
FROM Customers;