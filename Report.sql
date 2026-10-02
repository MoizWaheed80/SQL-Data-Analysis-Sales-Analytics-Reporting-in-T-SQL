with basequery as(
select 
	sales_key as Orders,
	product_key,
	order_date,
	quantity,
	f.sales as saleAmount,
	c.customer_key as customer_key,
	c.customer_number as customer_number,
	CONCAT(c.first_name, ' ', c.last_name) AS CustomerName,
	DATEDIFF(year, c.birth_date, GETDATE()) AS CustomerAge
from gold.fact_sale f
left join gold.dim_customer c
on f.customer_key = c.customer_key
where order_date is not null
),

customerAggrigation as (
select 
	customer_key,
	customer_number,
	CustomerName,
	CustomerAge,
	count(distinct Orders) as TotalOrder,
	sum(saleAmount) as TotalSale,
	sum(quantity) as TotalQuantity,
	count(distinct product_key) as TotalProducts,
	MAX(order_date) as [Latest order date],
	DATEDIFF(MONTH, min(order_date), MAX(order_date)) as LifeSpan
from basequery
group by 
	customer_key,
	customer_number,
	CustomerName,
	CustomerAge
)

select 
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

	DATEDIFF(DAY, [Latest order date], GETDATE()) as DateTilOrder,

	case 
		when TotalSale = 0 then 0
		ELSE TotalSale / TotalOrder
	end as AvgOrderValue,

	case
		when LifeSpan = 0 then TotalSale
		Else TotalSale / LifeSpan
	end as AvgSpending,

	TotalOrder,
	TotalSale,
	TotalQuantity,
	TotalProducts,
	LifeSpan
from customerAggrigation

