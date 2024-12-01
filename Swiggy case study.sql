-- user first 
-- food 
-- restaurants 
-- Relationship between user and restaurants oreders
-- Relationship between restaurants and food menu 
-- order details about orders 

-- Find customers who have never ordered 
use swiggy;
select * from orders;
select * from users;

SELECT * FROM orders o
RIGHT JOIN users u ON o.user_id = u.user_id
WHERE o.order_id IS NULL OR o.user_id IS NULL OR u.user_id IS NULL;


select name from
users
where user_id not in (select user_id from orders);

-- Average price/dish
select * from menu;
select * from food;

SELECT f.f_name, AVG(m.price) AS Average_price
FROM food f
LEFT JOIN menu m ON m.f_id = f.f_id
GROUP BY f.f_name;

select f_id, avg(price)
from menu
group by f_id;

SELECT f.f_name, AVG(m.price) AS Average_price
FROM food f
LEFT JOIN menu m ON m.f_id = f.f_id
GROUP BY f.f_name
order by Average_price desc;


-- Find top restautant in terms of numbers of orders for a given month
select * from restaurants;
select * from orders;

-- First we find those order hanppend in which month
select *, monthname(date) from orders;

select *,  monthname(date) as month from orders where monthname(date) like 'june';

select r_id, count(*) as month
from orders
where monthname(date) like 'june'
group by r_id;

select r_id, count(*) as month
from orders
where monthname(date) like 'june'
group by r_id
order by count(*) desc limit 1;

select r.r_name, count(*) as month
from orders o 
join restaurants r 
on o.r_id=r.r_id
where monthname(date) like 'june'
group by r.r_name
order by count(*) desc limit 1;

-- Let's find for may
select r.r_name, count(*) as month
from orders o 
join restaurants r
on o.r_id = r.r_id
where monthname(date) like 'may'
group by r.r_name
order by count(*) desc limit 1;

-- Restaurants with monthly sales > x for 
select * from orders;
select *, monthname(date) from orders;

select * from orders where monthname(date) like 'june';

select r_id, sum(amount) as revenue
from orders 
where monthname(date) like 'june'
group by r_id
order by revenue desc;


select r_id, sum(amount) as revenue
from orders 
where monthname(date) like 'june'
group by r_id
having revenue > 500
order by revenue desc;

select r.r_name, sum(amount) as revenue
from orders o
join restaurants r
on o.r_id = r.r_id
where monthname(date) like 'june'
group by r.r_name
having revenue > 500;

-- Show all orders with order details for a particular customer in a particular date range 
select * from users;
select * from order_details;
select * from orders;

select *, monthname(date) from orders;

-- we have to filter our data based on two case first based on customer name second based on date range  

-- First I will find how many orders palced by ankit 
select * from orders where user_id = ( select user_id from users where name like 'Ankit');

select * from orders where user_id = ( select user_id from users where name like 'Ankit')
and (date > '2024-06-10' and date < '2024-07-10');

select o.order_id, r.r_name 
from orders o 
join restaurants r 
on o.r_id = r.r_id 
where user_id = ( select user_id from users where name like 'Ankit')
and (date > '2024-06-10' and date < '2024-07-10');

select o.order_id, r.r_name, od.f_id
from orders o 
join restaurants r 
on o.r_id = r.r_id 
join order_details od
on o.order_id = od.order_id
where user_id = ( select user_id from users where name like 'Ankit')
and (date > '2024-06-10' and date < '2024-07-10');


select o.order_id, r.r_name, f.f_name
from orders o 
join restaurants r 
on o.r_id = r.r_id 
join order_details od
on o.order_id = od.order_id
join food f
on f.f_id = od.f_id
where user_id = ( select user_id from users where name like 'Ankit')
and (date > '2024-06-10' and date < '2024-07-10');

-- Find restaurants with max repeated customers 
select r_id, user_id, count(*) as visit from orders group by r_id, user_id;

select r_id, user_id, count(*) as visit 
from orders
group by r_id, user_id
having visit>1;

select r_id, count(*) as loyal_customer
from (select r_id, user_id, count(*) as visit 
from orders
group by r_id, user_id
having visit>1
) t
group by r_id;

select r_id, count(*) as loyal_customer
from (select r_id, user_id, count(*) as visit 
from orders
group by r_id, user_id
having visit>1
) t
group by r_id
order by loyal_customer limit 1;

select  r.r_name, count(*) as loyal_customer
from (select r_id, user_id, count(*) as visit 
from orders
group by r_id, user_id
having visit>1
) t
join restaurants r
on r.r_id = t.r_id
group by r.r_name
order by loyal_customer  desc limit 1;

-- Month over month revenue growth of swiggy 
select * , monthname(date) as 'Month' from orders;

select  monthname(date) as 'Month', sum(amount) from orders
group by monthname(date);

select  monthname(date) as 'Month', sum(amount) from orders
group by monthname(date)
ORDER BY MIN(date);

select  monthname(date) as 'Month', sum(amount) from orders
group by monthname(date)
ORDER BY MIN(date);

with sales as 
(select  monthname(date) as 'Month', sum(amount) as revenue from orders
group by monthname(date)
ORDER BY MIN(date)
)

select month, revenue, lag(revenue, 1) over (order by revenue) from Sales;

select month, ((revenue - prev)/prev)*100 from 
( with sales as 
(select  monthname(date) as 'Month', sum(amount) as revenue from orders
group by monthname(date)
ORDER BY MIN(date)
)

select month, revenue, lag(revenue, 1) over (order by revenue) as prev from Sales
) t;


-- Question 
select * 
from orders o 
join order_details od 
on o.order_id=od.order_id;

-- Now we'll perform group by based on user_id and f_id 
select o.user_id, od.f_id, count(*) as frequency
from orders o 
join order_details od 
on o.order_id=od.order_id
group by o.user_id, od.f_id
having frequency > 1;


with temp as (
select o.user_id, od.f_id, count(*) as frequency
from orders o 
join order_details od 
on o.order_id=od.order_id
group by o.user_id, od.f_id
) 
select * from temp t1 where t1.frequency = (select max(frequency) from temp t2);

with temp as (
select o.user_id, od.f_id, count(*) as frequency
from orders o 
join order_details od 
on o.order_id=od.order_id
group by o.user_id, od.f_id
) 
select u.name, f.f_name, t1.frequency
from temp t1 
join users u 
on u.user_id = t1.user_id
join food f 
on f.f_id = t1.f_id
where t1.frequency = (select max(frequency) 
from temp t2 
where t2.user_id = t1.user_id);

