select 
	count(distinct(sale.customer_key)) as CustomerId,
	datetrunc(month,sale.order_date) as Dates,
	SUM(sale.quantity) TotalQuantity,
	SUM(sale.price) as TotalPrice
from gold.fact_sale sale
where order_date is not null
Group by datetrunc(month,sale.order_date) 

