CREATE VIEW gold.Report2
AS
    WITH baseValue AS (
        SELECT
            f.sales_key as order_number,
            f.order_date,
            f.customer_key,
            f.sales as sales_amount,
            f.quantity,
            p.customer_key product_key,
            p.product_name,
            p.category,
            p.sub_category as subcategory,
            p.product_cost as cost
        FROM gold.fact_sale f
        LEFT JOIN gold.dim_product p
            ON f.product_key = p.customer_key
        WHERE f.order_date IS NOT NULL
    ),

    secondCte as (
    SELECT 
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        MAX(order_date) AS last_sale_date,
        COUNT(DISTINCT order_number) AS total_orders,
	    COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
	    ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
    FROM baseValue

    group by
            product_key,
            product_name,
            category,
            subcategory,
            cost
    )

    select 
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        lifespan,
        last_sale_date,
        CASE
		    WHEN total_sales > 50000 THEN 'High-Performer'
		    WHEN total_sales >= 10000 THEN 'Mid-Range'
		    ELSE 'Low-Performer'
	    END AS product_segment,

        datediff(day, last_sale_date, GETDATE()) TimetillLastOrder,
    
        case 
            when total_orders = 0 then 0
            Else total_sales/ total_quantity
        end as averageOrderRevenue,

        CASE
		    WHEN lifespan = 0 THEN total_sales
		    ELSE total_sales / lifespan
	    END AS avg_monthly_revenue,

        total_orders,
	    total_customers,
        total_sales,
        total_quantity,
	    avg_selling_price
    from secondCte