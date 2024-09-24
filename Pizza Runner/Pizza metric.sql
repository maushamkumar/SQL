use pizza_runner;

-- Question 1
-- How many pizza were ordered?
-- Using the count function:
select count(*) as number_of_orders 
from customer_orders;

-- The were 14 pizza ordered 

-- Question 2 
-- How many unique customer orders were made?

-- I used the functions count distinct and group by 
select customer_id, count(distinct order_id) as unique_orders
from customer_orders
group by customer_id;

-- Question 3 
-- How many successful orders were delivered by each runner 

-- I used the functions count, where and group by 
SELECT runner_id, COUNT(*) AS successful_orders_delivered
FROM runner_orders
WHERE cancellation = '' OR cancellation IS NULL
GROUP BY runner_id;

-- Question 4
-- How many of each type of pizza was delivered?
-- To solve this query we have to perfrom join between pizza_name in custome_orders

select * from pizza_names;
select * from customer_orders;
select pn.pizza_name, count(o.order_id) as Number_of_orders
from customer_orders o
join pizza_names pn
on pn.pizza_id = o.pizza_id
group by pn.pizza_name
order by count(o.order_id) desc;

-- First, I joined the tables pizza_names and customer_orders
select Pizza_name, order_id, customer_id
from pizza_names
inner join customer_orders
on pizza_names.pizza_id = customer_orders.pizza_id;

-- Then I used the functions COUNT, GROUP BY and ORDER BY (remembering to use CAST for pizza_name column) 
select customer_id, count(*) as Number_of_pizza, pizza_name as Type_of_pizza 
from pizza_names
inner join customer_orders
on pizza_names.pizza_id = customer_orders.pizza_id
group by customer_id, Type_of_pizza 
order by  customer_id desc;

-- Question 5
-- What was the maximum number of pizza delivered in a single order?

select * from customer_orders
;
select * from runner_orders;

select ro.cancellation, co.customer_id
from customer_orders co
join runner_orders ro
on co.order_id = ro.order_id
;

SELECT co.customer_id, ro.cancellation, COUNT(co.customer_id) AS No_of_order
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NOT NULL
GROUP BY co.customer_id, ro.cancellation
ORDER BY co.customer_id DESC
;

-- First, I joined the tables customer_orders and runner_orders, eliminating the orders that had been cancelled:
select co.order_id, ro.distance, co.customer_id, ro.cancellation
from customer_orders co 
join runner_orders ro
on ro.order_id = co.order_id
where ro.distance <> ' ';

-- Then, I did one table for counting the number of coustomers that had palced orders, using the count function :
select co.order_id, count(co.customer_id) As Pizza_per_order
from customer_orders co 
join runner_orders ro
on ro.order_id = co.order_id
where ro.distance <> ' '
group by ro.order_id;

-- Next, I put that on a cte in order to use the function count and max together:
with cte as 
(select co.order_id, count(co.customer_id) As Pizza_per_order
from customer_orders co 
join runner_orders ro
on ro.order_id = co.order_id
where ro.distance <> ' '
group by ro.order_id)
select max(pizza_per_order) as number_of_pizzas
from cte;

-- Using subquery 
SELECT MAX(Pizza_per_order) AS number_of_pizzas
FROM (
    SELECT co.order_id, COUNT(co.customer_id) AS Pizza_per_order
    FROM customer_orders co
    JOIN runner_orders ro ON ro.order_id = co.order_id
    WHERE ro.distance <> ''
    GROUP BY ro.order_id
) AS subquery;

-- Question 7
-- For each customer, how many delivered pizzas had at least 1 change and hwo many had no change 

-- First, I joined the tables runer_orders and customer_orders, in order to select only the pizzas that had been delivered:
select * from customer_orders;
select co.order_id, co.customer_id, co.exclusions, co.extras
from customer_orders co 
join runner_orders ro
on ro.order_id = co.order_id
where ro.distance <> ' ';


-- Then I applied sum and case functions:
select co.customer_id, 
sum(case
		WHEN co.exclusions <> ' ' OR co.extras <> ' ' THEN 1
  		ELSE 0
  		END) AS at_least_1_change,
        SUM(CASE 
  		WHEN exclusions = ' ' AND extras = ' ' THEN 1 
  		ELSE 0
  		END) AS no_change
        from runner_orders ro
        join customer_orders co
        on ro.order_id = co.order_id
        where ro.distance <> ' '
        group by co.customer_id;
        
-- Question 8
-- How many pizzas were deivered that had both exclusions and extra
-- First, I joined the tables runner_orders and customer_orders, in order to select only the pizzas that had been delivered:
select * from customer_orders;
select co.order_id, co.customer_id, co.exclusions, co.extras
from customer_orders co 
join runner_orders ro
on ro.order_id = co.order_id
where ro.distance <> ' ';

-- Then, I use the function sum, case and where (To filter out the customers that wanted both exclusions):
select co.customer_id
sum, (case
when co.exclusions <> ' ' and co.extras <> ' ' then 1
else 0
end) as exclusions_and_extras
from runner_orders ro
join customer_orders co
on ro.order_id = co.order_id
where ro.distance <> ' '
and co.exclusions <> ' '
and extras <> ' '
group by co.customer_id ;

SELECT customer_id,  
  		sum,(CASE 
		WHEN exclusions <> ' ' AND extras <> ' ' THEN 1 
  		ELSE 0
  		END) AS exclusions_and_extras
  		FROM runner_orders
  		INNER JOIN customer_orders
  		ON runner_orders.order_id = customer_orders.order_id
  		WHERE distance <> ' '
  		AND exclusions <> ' ' 
  		AND extras <> ' '
  		GROUP BY customer_id;
		
        
-- Question 9 
-- what was the total volume of pizzas ordered for each hour of the day?

-- First, I joined the tables runner_orders and customer_orders with the information necessary for this table:
select * from runner_orders;

select ro.order_id, co.customer_id, co.order_time
from runner_orders ro
join customer_orders co
on ro.order_id = co.order_id
where distance <> ' ';

-- Using the function DATEPART to extract the time of the day:
SELECT HOUR(co.order_time) AS hour_of_day,
       COUNT(ro.order_id) AS number_of_pizzas
FROM runner_orders ro
JOIN customer_orders co ON ro.order_id = co.order_id
WHERE distance <> ' '
GROUP BY HOUR(co.order_time);


-- Question 10 
-- What was the volume of orders for each day of the week

-- Similar query as the question before, using DATENAME instead
select weekday(co.order_time) as day_of_the_week, 
count(*) as number_of_pizzas
from runner_orders ro
join customer_orders co
on ro.order_id = co.order_id
where distance <> ' '
group by weekday(co.order_time);

