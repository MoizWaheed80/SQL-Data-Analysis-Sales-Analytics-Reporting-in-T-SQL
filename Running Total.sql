select 
	Dates,
	TotalPrice,
	SUM(TotalPrice) over(partition by Dates order by Dates) As [Running Total]
from
(select 
	datetrunc(month,sale.order_date) as Dates,
	SUM(sale.price) as TotalPrice
from gold.fact_sale sale
where order_date is not null
Group by datetrunc(month,sale.order_date) 
)t 

