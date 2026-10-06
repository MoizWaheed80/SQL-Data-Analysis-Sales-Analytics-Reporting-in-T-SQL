IF SCHEMA_ID('final') IS NULL
    EXEC('CREATE SCHEMA final;');
GO

DROP TABLE IF EXISTS final.fact;
GO

SELECT
    s.SalesId,
    c.CustomerId AS CustomerKey,
    p.ProductId  AS ProductKey,
    st.StoreId   AS StoreKey,
    s.InvoiceNo,
    s.OrderDate,
    s.UnitPrice,
    s.Quantity,
    s.DiscountPct,
    s.LineTotal,
    s.PaymentMethod,
    s.SalesRepName,
    s.ShipDate,
    s.ShipMode
INTO final.fact
FROM raw.Sale s

LEFT JOIN raw.CustomerInfo c
    ON c.CustomerName = s.CustomerName
    AND c.CustomerEmail = s.CustomerEmail
    AND c.CustomerCity = s.CustomerCity
    AND c.CustomerCountry = s.CustomerCountry
    AND c.CustomerSegment = s.CustomerSegment

LEFT JOIN raw.ProductInfo p
    ON p.ProductName = s.ProductName
    AND p.Category = s.Category
    AND p.SubCategory = s.SubCategory
    AND p.Brand = s.Brand

LEFT JOIN raw.StoreInfo st
    ON st.StoreName = s.StoreName
    AND st.StoreCity = s.StoreCity
    AND st.SalesRepName = s.SalesRepName;
GO

ALTER TABLE final.fact
ALTER COLUMN SalesId BIGINT NOT NULL;
GO

ALTER TABLE final.fact
ADD CONSTRAINT PK_fact PRIMARY KEY (SalesId);
GO

SELECT *
FROM final.fact
ORDER BY SalesId;