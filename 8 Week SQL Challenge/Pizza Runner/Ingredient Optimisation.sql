use `sql challenge`;

select * from pizza_names;
-- Here we have pizza id and pizza_name as of now we have only two types of pizza. 
select * from pizza_recipes;
-- Here we have pizza_id and toppings 
select * from pizza_toppings;
-- Here we have topping_id and topping_name right. 



-- 1. What are the standard ingredients for each pizza?
SELECT 
    pn.pizza_name, 
    pt.topping_name
FROM 
    pizza_recipes pr
JOIN 
    pizza_names pn ON pr.pizza_id = pn.pizza_id
JOIN 
    pizza_toppings pt ON FIND_IN_SET(pt.topping_id, pr.toppings)
ORDER BY 
    pn.pizza_name, pt.topping_name;


-- 2. What was the most commonly added extra?
select 
	pt.topping_name,
    count(*) as extra_count
from 
	customer_orders co 
join pizza_toppings pt on find_in_set(pt.topping_id, co.extras)
group by 
	pt.topping_name 
order by 
	extra_count
limit 1;

-- 3. What was the most common exclusion?
select 
	pt.topping_name, 
    count(*) as exclusion_count
from customer_orders co 
join pizza_toppings pt on find_in_set(pt.topping_id, co.exclusions)
group by 
	pt.topping_name
order by 
	exclusion_count desc

limit 1;
-- 4. Generate an order item for each record in the `Customer_orders` table in the format of one of the following. 
-- Meat Lovers 
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon 
-- Meat Lovers - Exclude cheese, Bacon - Extra Mushroom, Peppers 

    SELECT 
    co.order_id, 
    CONCAT(
        pn.pizza_name,
        CASE 
            WHEN co.exclusions <> '' THEN CONCAT(' - Exclude ', GROUP_CONCAT(pt_exclude.topping_name))
            ELSE '' 
        END,
        CASE 
            WHEN co.extras <> '' THEN CONCAT(' - Extra ', GROUP_CONCAT(pt_extra.topping_name))
            ELSE '' 
        END
    ) AS order_item
FROM 
    customer_orders co
JOIN 
    pizza_names pn ON co.pizza_id = pn.pizza_id
LEFT JOIN 
    pizza_toppings pt_exclude ON FIND_IN_SET(pt_exclude.topping_id, co.exclusions)
LEFT JOIN 
    pizza_toppings pt_extra ON FIND_IN_SET(pt_extra.topping_id, co.extras)
GROUP BY 
    co.order_id, pn.pizza_name, co.exclusions, co.extras
ORDER BY 
    co.order_id;


-- 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the `Customer_orders` Table and add a 2x in front of any relevant ingredients 
-- For example "Meat Lovers: 2XBaco, Beef, ... Salami

SELECT 
    co.order_id,
    CONCAT(
        pn.pizza_name, ': ',
        GROUP_CONCAT(
            CASE 
                WHEN FIND_IN_SET(pt.topping_id, co.extras) THEN CONCAT('2x', pt.topping_name)
                ELSE pt.topping_name
            END
            ORDER BY pt.topping_name
        )
    ) AS ingredients_list
FROM 
    customer_orders co
JOIN 
    pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN 
    pizza_recipes pr ON co.pizza_id = pr.pizza_id
JOIN 
    pizza_toppings pt ON FIND_IN_SET(pt.topping_id, pr.toppings)
GROUP BY 
    co.order_id, pn.pizza_name
ORDER BY 
    co.order_id;


-- 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
select 
	pt.topping_name, 
    count(pt.topping_name) as total_quantity
from 
	runner_orders ro 
join customer_orders co 
	on ro.order_id = co.order_id
join pizza_recipes pr 
	on co.pizza_id = pr.pizza_id
join pizza_toppings pt 
	on find_in_set(pt.topping_id, pr.toppings)
where ro.distance != 0
group by pt.topping_name
order by total_quantity desc;


select * from customer_orders;