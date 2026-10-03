select 
	sum(product_cost) as TotalCost,
	division
from
(select 
	product_cost,
	case 
		when product_cost < 100 then 'Less-100'
		when product_cost between 100 and 500 then '100-500'
		when product_cost between 500 and 1000 then '500-1000'
		when product_cost >1000 then 'Greater-1000'
	End as division 
from gold.dim_product) t
group by division
order by TotalCost 