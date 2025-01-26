
use `sql challenge`;

-- 1. How many pizzas were ordered?
select count(*) as order_pizza from customer_orders;


-- 2. How many unique customer orders were made?
select count(distinct order_id) as user_id  from customer_orders;


-- 3. How many successful orders were delivered by each runner?

-- As we have seen our data whenever order got cancel we don't data inside pick-time, distance or duration
select runner_id, 
count(order_id) as successful_orders
from runner_orders
where distance != 0 
group by runner_id;

-- 4. How many of each type of pizza was delivered?
select 
	p.pizza_name, 
    count(c.pizza_id) as delivered_pizza_count
    from customer_orders as c
    join runner_orders as r 
    on c.order_id = r.order_id
    join pizza_names as p 
    on c.pizza_id = p.pizza_id 
    where r.distance != 0 
    group by p.pizza_name;
-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT 
  c.customer_id, 
  p.pizza_name, 
  COUNT(p.pizza_name) AS order_count
FROM customer_orders AS c
JOIN pizza_names AS p
  ON c.pizza_id= p.pizza_id
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id;
-- 6. What was the manimum number of pizzas delivered in a single order?
with pizza_count as (
select 
	c.order_id,
	count(c.pizza_id) pizza_per_order
from customer_orders as c
join runner_orders as r
	on c.order_id = r.order_id
where r.distance != 0
group by c.order_id
)
select 
	max(pizza_per_order) as pizza_count
from pizza_count;

-- 7. For each customer, how many delivered pizzaz had at least 1 change and how many had no changes?

SELECT 
  c.customer_id,
  SUM(
    CASE WHEN c.exclusions <> '' and c.extras <> '' THEN 1
    ELSE 0
    END) AS at_least_1_change,
  SUM(
    CASE WHEN c.exclusions = '' or c.extras = '' THEN 1 
    ELSE 0
    END) AS no_change
FROM customer_orders_temp AS c
JOIN runner_orders AS r
  ON c.order_id = r.order_id
WHERE r.distance != 0
GROUP BY c.customer_id
ORDER BY c.customer_id;
-- 8. How many pizzas were delivered that had both exclusions and extras?
select 
	sum(
		case when exclusions != ''  and extras != '' then 1 
        else 0 
        end) as pizza_count_w_exclusions_extras
from customer_orders_temp as c 
join runner_orders as r 
on c.order_id = r.order_id
where r.distance != 0
and exclusions <> ' ' 
and extras <> ' ';
-- 9. What was the total volume of pizzas ordered for each hours of the day?
select Hour(order_time) as hour_of_day, 
count(order_id) as pizza_count
from customer_orders
group by HOUR(order_time)
order by HOUR(order_time);
-- 10. What was the volume of orders for each day of the week or month or year?
SELECT 
    DAYNAME(DATE_ADD(order_time, INTERVAL 2 DAY)) AS day_of_week, 
    COUNT(order_id) AS total_pizzas_ordered
FROM customer_orders
GROUP BY DAYNAME(DATE_ADD(order_time, INTERVAL 2 DAY));
