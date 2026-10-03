with saleCte as (
	select 
		p.category as Category,
		sum(s.sales) TotalSale
	from gold.fact_sale s
	inner join gold.dim_product p
	ON s.product_key = p.customer_key
	GROUP By p.category
)

select 
	Category,
	TotalSale,
	concat(round((cast(TotalSale as float) / sum(TotalSale) over ()) * 100, 2), '%') as PercentageTotal
from saleCte
order by TotalSale desc