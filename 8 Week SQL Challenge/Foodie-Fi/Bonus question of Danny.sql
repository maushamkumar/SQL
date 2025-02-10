use `sql challenge`;


-- Recreate the table with: Customer_id, order_date, product_name, price, member(Y?N) 

select 
	s.customer_id, 
    s.order_date, 
    m.product_name, 
    m.price, 
    case 
		when mb.join_date > s.order_date then 'N'
        when mb.join_date < s.order_date then 'Y'
        else 'N' end as member_status 
from sales s
left join members mb
on s.customer_id = mb.customer_id 
inner join menu m
on s.product_id = m.product_id 
order by s.customer_id, s.order_date;


-- Rank All The Things 
-- Danny also requires futher information about the ranking of customer products, 
-- but he purposely does not need the ranking for no-member purchases so he expects
-- null ranking values for the records when customers are not yet part of the loyalty program. 

with customers_data as (
select 
	s.customer_id, 
    s.order_date, 
    m.product_name, 
    m.price, 
    case 
		when mb.join_date > s.order_date then 'N'
        when mb.join_date < s.order_date then 'Y'
        else 'N' end as member_status 
from sales s
left join members mb
on s.customer_id = mb.customer_id 
inner join menu m
on s.product_id = m.product_id 
order by s.customer_id, s.order_date)

select 
	*, 
    case 
		when member_status = 'N' then Null 
        else rank() over(partition by customer_id, member_status order by order_date ) end as ranking 
        from customers_data
    ;
