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

select s.customer_id, 
s.plan_id, 
p.plan_name,
row_number() over(partition by s.customer_id order by s.plan_id) as plan_rank
from subscriptions s
join plans p 
	on s.plan_id = p.plan_id

)select count(*) as churn_count, 
round(100 * count(*) / (select count(distinct customer_id) from subscriptions), 0) as churn_percentage
from ranking
where plan_id = 4 -- Filter to churn plan 
and plan_rank = 2 -- Filter to rank 2 as customers who churned immediately after trial have churn plan ranked as 2
;
-- 6. What is the number and percentage of customer plans after their initial free trail? 
/* 
Find customer's next plan which is located in the next row using LEAD() run the next_plan_cte separately to view the next plan results and understand how LEAD() works. 

Filter for non-null next_plan. Why? Because a next_plan with null values means that the customer has churned 

Filter for plan_id = 0 as every customer has to start from the trial plan at 0.
*/

with next_plan_cte as (
select 
	customer_id, 
    plan_id, 
    lead(plan_id, 1) over (partition by customer_id order by plan_id) as next_plan
from subscriptions

)
select next_plan, 
count(*) as conversions, 
round(100 * count(*) / (
select count(distinct customer_id) from subscriptions), 1) as conversion_percentage
from next_plan_cte
where next_plan is not null 
and plan_id = 0 
group by next_plan
order by next_plan;

-- 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
with next_plan as (
select 
	customer_id, 
    plan_id, 
    start_date, 
    lead(start_date, 1) over(partition by customer_id order by start_date) as next_date 
from subscriptions 
where start_date <= '2020-12-31'
), 
-- Find customer breakdown with existing plans on or after 31 Dec 2020 
customer_breakdown as (
select
	plan_id, 
    count(distinct customer_id) as customers
from next_plan
where 
	(next_date is not null and (start_date < '2020-12-31' 
    and next_date > '2020-12-31')) 
    or (next_date is null and start_date < '2020-12-31') 
    group by plan_id
)
select all	plan_id, customers, 
	round(100 * customers / 
	(select count(distinct customer_id) from subscriptions), 1) as percentage 
from customer_breakdown 
group by plan_id, customers 
order by plan_id;
-- 8. How many customers have upgraded to an annual plan in 2020?
select 
	count(distinct customer_id) as unique_customer
from subscriptions 
where plan_id = 3 
	and start_date <= '2020-12-31';

-- 9. How many days on average doest it take for a customer to an annual plan from the day they join Foddie-Fi?

-- Filter results to customers at trail plan = 0 

WITH trial_plan AS (
    SELECT 
        customer_id, 
        MIN(start_date) AS trial_date
    FROM subscriptions
    WHERE plan_id = 0
    GROUP BY customer_id
), 
annual_plan AS (
    SELECT 
        customer_id, 
        MIN(start_date) AS annual_date
    FROM subscriptions
    WHERE plan_id = 3
    GROUP BY customer_id
)
SELECT 
    ROUND(AVG(DATEDIFF(ap.annual_date, tp.trial_date)), 0) AS avg_days_to_upgrade
FROM trial_plan tp
JOIN annual_plan ap 
    ON tp.customer_id = ap.customer_id
WHERE ap.annual_date > tp.trial_date;


-- 10. Can you further breakdown his average value into 30 day periods (i.e 0-30 days, 31-60 days etc)?

-- Filter results to customers at trial plan = 0 
WITH trial_plan AS (
    SELECT 
        customer_id, 
        MIN(start_date) AS trial_date
    FROM subscriptions
    WHERE plan_id = 0
    GROUP BY customer_id
), 
annual_plan AS (
    SELECT 
        customer_id, 
        MIN(start_date) AS annual_date
    FROM subscriptions
    WHERE plan_id = 3
    GROUP BY customer_id
),
-- Sort values above in buckets of 12 with range of 30 days each bins as 
bins as (SELECT 
    CASE
        WHEN DATEDIFF(ap.annual_date, tp.trial_date) BETWEEN 0 AND 30 THEN 1
        WHEN DATEDIFF(ap.annual_date, tp.trial_date) BETWEEN 31 AND 60 THEN 2
        WHEN DATEDIFF(ap.annual_date, tp.trial_date) BETWEEN 61 AND 90 THEN 3
        WHEN DATEDIFF(ap.annual_date, tp.trial_date) BETWEEN 91 AND 120 THEN 4
        WHEN DATEDIFF(ap.annual_date, tp.trial_date) BETWEEN 121 AND 150 THEN 5
        WHEN DATEDIFF(ap.annual_date, tp.trial_date) BETWEEN 151 AND 180 THEN 6
        WHEN DATEDIFF(ap.annual_date, tp.trial_date) BETWEEN 181 AND 210 THEN 7
        WHEN DATEDIFF(ap.annual_date, tp.trial_date) BETWEEN 211 AND 240 THEN 8
        WHEN DATEDIFF(ap.annual_date, tp.trial_date) BETWEEN 241 AND 270 THEN 9
        WHEN DATEDIFF(ap.annual_date, tp.trial_date) BETWEEN 271 AND 300 THEN 10
        WHEN DATEDIFF(ap.annual_date, tp.trial_date) BETWEEN 301 AND 330 THEN 11
        WHEN DATEDIFF(ap.annual_date, tp.trial_date) BETWEEN 331 AND 360 THEN 12
        ELSE 13
    END AS avg_days_to_upgrade_bucket
FROM trial_plan tp
JOIN annual_plan ap 
    ON tp.customer_id = ap.customer_id

)
select 
	
    CONCAT((avg_days_to_upgrade_bucket - 1) * 30, ' - ', avg_days_to_upgrade_bucket * 30, ' days') AS breakdown,

    count(*) as customers 
from bins 
group by avg_days_to_upgrade_bucket
order by avg_days_to_upgrade_bucket;
-- 11. How many custoemrs downgraded from a pro monthly to a basice monthly plan in 2020?
-- Retrieve next plan's start date located in the next row based on current ro 
with next_plan_cte as 
	( select
		customer_id, 
        plan_id, 
        start_date, 
        LEAD(plan_id, 1) over(partition by customer_id order by plan_id) as next_plan
from subscriptions
)
select 
	count(*) as downgraded 
from next_plan_cte
where start_date <= '2020-12-31'
and plan_id = 2
and next_plan = 1;




