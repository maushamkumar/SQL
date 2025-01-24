use `sql challenge`;

-- Table Customer_orders
-- Looking at the customer_orders table below, we can see that there are 
-- In the `exclusions` column, there are missing/blank spaces ' ' and null values. 
-- In the `extras` column, there are missing/blank spaces ' ' and null values. 

-- Create a temporary table with all the columns
-- Rename null values in exlusions and extras columns and replace with blank space

CREATE TEMPORARY TABLE customer_orders_temp (
    order_id INT,
    customer_id INT,
    pizza_id INT,
    exclusions VARCHAR(255),
    extras VARCHAR(255),
    order_time DATETIME
);


INSERT INTO customer_orders_temp
SELECT 
    order_id, 
    customer_id, 
    pizza_id, 
    CASE 
        WHEN exclusions IS NULL OR exclusions = 'null' THEN ' ' 
        ELSE exclusions 
    END AS exclusions, 
    CASE 
        WHEN extras IS NULL OR extras = 'null' THEN ' ' 
        ELSE extras 
    END AS extras, 
    order_time
FROM pizza_runner.customer_orders;

select * from customer_orders_temp;

-- Table: runner_orders 
-- Looking at the runner_order table below, we can see that there are 
-- In the pickup_time column, there are null value 
-- In the distance column, there are null value 
-- In the duration column, there are null value 
-- In the pickup_time column, there are ' '  and null value 

-- Now It's time to clean it 
-- In pickup_time column, remove nulls and replace with blank space ' '.
-- In distance column, remove "km" and nulls and replace with blank space ' '.
-- In duration column, remove "minutes", "minute" and nulls and replace with blank space ' '.
-- In cancellation column, remove NULL and null and and replace with blank space ' '.

CREATE TEMPORARY TABLE runner_orders_temp (
    order_id INT,
    runner_id INT,
    pcikup_time datetime,
    distance varchar(255),
	duration varchar(255),
    cancellation varchar(255) )
    ;
    
    
insert into runner_orders_temp 
select 
order_id, 
runner_id, 
case 
	when pickup_time like 'null' then ' ' 
    else pickup_time
    end as pickup_time, 
case 	
	when  distance like 'null' then ' ' 
    when distance like '%km' then trim('km' from distance) 
    else distance
    end as distance, 
case 
	when duration like 'null' then ' ' 
    when duration like 'mins' then trim('mins' from duration)
    when duration like 'minute' then trim('minute' from duration)
    when duration like 'minutes' then trim('minutes' from duration)
    else duration 
    end as duration,
case 
	when cancellation is null or cancellation like 'null' then 'kuchbhi'
    else cancellation
    end as cancellation
from pizza_runner.runner_orders;
   
select * from runner_orders_temp;
    