with YearlySaleCte as (
	select 
		distinct(p.product_name) as ProductName,
		YEAR(s.order_date) as OrderDate,
		sum(s.sales) TotalSale
	from gold.fact_sale s
	inner join gold.dim_product p
	ON s.product_key = p.customer_key
	where order_date is not null
	GROUP By p.product_name, YEAR(s.order_date)
)

select 
	OrderDate,
	ProductName,
	TotalSale,
	Avg(TotalSale) over (partition by ProductName) as AvgSale,
	TotalSale - Avg(TotalSale) over (partition by ProductName) diff,

	case 
		when TotalSale - Avg(TotalSale) over (partition by ProductName) > 0 then 'Above Avg'		
		when TotalSale - Avg(TotalSale) over (partition by ProductName) < 0 then 'Below Avg'
		Else 'Avg'
	end as Avg_change,

	lag(TotalSale) over (partition by ProductName order by OrderDate) [last Sale],
	TotalSale - lag(TotalSale) over (partition by ProductName order by OrderDate) [Change],

	case 
		when lag(TotalSale) over (partition by ProductName order by OrderDate) > 0 then 'Increase'		
		when lag(TotalSale) over (partition by ProductName order by OrderDate) < 0 then 'Decrease'
		Else 'No_change'
	end as Avg_change
from YearlySaleCte
order by ProductName, OrderDate