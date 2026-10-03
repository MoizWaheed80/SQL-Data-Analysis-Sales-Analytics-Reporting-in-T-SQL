
CREATE VIEW gold.report_Customer
AS
WITH basequery AS (
    SELECT 
        sales_key AS Orders,
        product_key,
        order_date,
        quantity,
        f.sales AS saleAmount,
        c.customer_key AS customer_key,
        c.customer_number AS customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS CustomerName,
        DATEDIFF(YEAR, c.birth_date, GETDATE()) AS CustomerAge
    FROM gold.fact_sale AS f
    LEFT JOIN gold.dim_customer AS c
        ON f.customer_key = c.customer_key
    WHERE order_date IS NOT NULL
),

customerAggrigation AS (
    SELECT 
        customer_key,
        customer_number,
        CustomerName,
        CustomerAge,
        COUNT(DISTINCT Orders) AS TotalOrder,
        SUM(saleAmount) AS TotalSale,
        SUM(quantity) AS TotalQuantity,
        COUNT(DISTINCT product_key) AS TotalProducts,
        MAX(order_date) AS [Latest order date],
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS LifeSpan
    FROM basequery
    GROUP BY 
        customer_key,
        customer_number,
        CustomerName,
        CustomerAge
)

SELECT 
    customer_key,
    customer_number,
    CustomerName,
    CustomerAge,

    CASE
        WHEN CustomerAge < 20 THEN 'Under 20'
        WHEN CustomerAge >= 20 AND CustomerAge < 30 THEN '20-29'
        WHEN CustomerAge >= 30 AND CustomerAge < 40 THEN '30-39'
        WHEN CustomerAge >= 40 AND CustomerAge < 50 THEN '40-49'
        ELSE '50+'
    END AS AgeGroup,

    CASE 
        WHEN LifeSpan >= 12 AND TotalSale >= 5000 THEN 'VIP'
        WHEN LifeSpan >= 12 AND TotalSale < 5000 THEN 'Regular'
        ELSE 'New'
    END AS customerSegment,

    DATEDIFF(DAY, [Latest order date], GETDATE()) AS DateTilOrder,

    CASE 
        WHEN TotalSale = 0 THEN 0
        ELSE TotalSale / TotalOrder
    END AS AvgOrderValue,

    CASE
        WHEN LifeSpan = 0 THEN TotalSale
        ELSE TotalSale / LifeSpan
    END AS AvgSpending,

    TotalOrder,
    TotalSale,
    TotalQuantity,
    TotalProducts,
    LifeSpan
FROM customerAggrigation;