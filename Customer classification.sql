SELECT 
    COUNT(CustomerId) AS Customer,
    Rating
FROM
(
    SELECT 
        CustomerId,
        TotalSale,
        firstOrder,
        LastOrder,
        diff,
        CASE 
            WHEN diff >= 12 AND TotalSale >= 5000 THEN 'VIP'
            WHEN diff >= 12 AND TotalSale < 5000 THEN 'Regular'
            ELSE 'New'
        END AS Rating
    FROM
    (
        SELECT 
            c.customer_id AS CustomerId,
            SUM(sales) AS TotalSale,
            MIN(order_date) AS firstOrder,
            MAX(order_date) AS LastOrder,
            DATEDIFF(
                MONTH,
                MIN(order_date),
                MAX(order_date)
            ) AS diff
        FROM gold.fact_sale AS f
        LEFT JOIN gold.dim_customer AS c
            ON f.customer_key = c.customer_key
        GROUP BY c.customer_id
    ) AS t
) AS t2
GROUP BY Rating
ORDER BY Customer DESC;