use `sql challenge`;

select * from plans;
-- First let's talk about plans table 
-- plan_id = unique id for each plan. 
/* plan_name = here we have 5 type of plane
-- trial = New signup user 
-- Basic monthly some limitation for a month
-- pro monthly everything you'll get for a month
-- pro annual here you'll get everything for a month
-- churn No longer plan memeber.
*/
-- Price = Price of the each plan

select * from subscriptions;
-- Second table 
-- Customer_id = customer id of each customer 
-- plan_id = what kind of plan they have purchase. 
-- start _date = when they have purchase there plan.


-- 1. How many customers has Foodie-Fi ever had?
select count(distinct customer_id) from subscriptions;


-- 2. What is the monthly distribution of trail plan start_date values for our dataset-use the start of the month as the group by value. 

-- Question is asking for the monthly numbers of users on trial plan. 
-- Firstly, I extract numerical month using Date_part. 
-- Then, i use to_char to extract the string or name of the month. 
-- Date_part is used to extract numerical values from a date, whereas 
-- TO_char extracts the string value (i.e January, Wednesday) 
-- Filter for plan_id = 0 for trial plans.

SELECT 
    DATE_FORMAT(start_date, '%M') AS month_name, 
    COUNT(plan_id) AS trial_subscriptions, 
    MONTH(start_date) AS month_date
FROM 
    subscriptions
WHERE 
    plan_id = 0
GROUP BY 
    MONTH(start_date), DATE_FORMAT(start_date, '%M')
ORDER BY 
    month_date;


-- 3. What plan start_date values occur after the year 2020 for our dataset?  show the breakdown by count of the events for each plan_name?

-- Question is asking for the number of plans for start dates occurring on 1 jan 2021 and after grouped by plan names. 
-- Filter plans with start_date occurring on 2021-01-01 and after. 
-- Group and order results by plan. 

select 
	p.plan_id, 
	p.plan_name, 
    count(*) as events
from subscriptions s 
join plans p 
on s.plan_id = p.plan_id
where start_date > '2021-01-01'
group by 
	p.plan_id, 
	p.plan_name
order by 
	p.plan_id;


-- 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
-- Find the number of customers who churned 

select count(*) as churn_customer, 
	round(100 * count(*) / (select count(distinct customer_id) from subscriptions
    )
    , 1) as churn_percentage 
from subscriptions
where plan_id = 4;

-- 5. How many customers have churned straight after their inital free trail - what percentage is this rounded to the nearest whole numbers?

/* In order to identify which customer churned straight after the trail plan, 
rank each customer's plans uisng row_number.  and partition by usnique customer.

If a customer churned immediately after free trail the plan ranking would like this 

-- Trail plan  1 
-- Churned 2 

else in other manner.

*/ 


with ranking as (
select customer_id, 
row_number() over(partition by plan_id) from subscriptions

)
-- 6. What is the number and percentage of customer plans after their initial free trail? 

-- 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

-- 8. How many customers have upgraded to an annual plan in 2020?

-- 9. How many days on average doest it take for a customer to an annual plan from the day they join Foddie-Fi?

-- 10. Can you further breakdown his average value into 30 day periods (i.e 0-30 days, 31-60 days etc)?

-- 11. How many custoemrs downgraded from a pro monthly to a basice monthly plan in 2020?