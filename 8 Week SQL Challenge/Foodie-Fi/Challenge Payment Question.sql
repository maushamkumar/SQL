use `sql challenge`;

/*
The Foodie-Fi team wants you to create a new payments
table for the year 2020 that includes amounts paid by
each customer in the subscriptions table with the following requirements:

1. Monthly payments always occur on the same day of month
as the original start_date of any monthly paid plan.

2. Upgrades from basic to monthly or pro plans are reduced
by the current paid amount in that month and start immediately.

3. Upgrades from pro monthly to pro annual are paid at
the end of the current billing period and also
starts at the end of the month period.

4. Once a customer churns they will no longer make payments.

*/


/* First Step 
The first thing we want to do is join the subscriptions table to plans table, eliminating records where start_date > 2020-12-31 and plan_name not in 
(trail and churn) since no payments were made for those two plans. we will also add a column named next_date. I will explain later why we need this column.
*/

select s.customer_id, s.plan_id, s.start_date, 
lead(s.start_date, 1) over(partition by s.customer_id order by s.start_date, s.plan_id) as next_date, 
p.price as amount 
from subscriptions s
join plans p
on s.plan_id = p.plan_id 
where s.start_date <= '2020-12-31' and p.plan_name not in ('trial', 'churn');

/* Step 2 
 It also shows that some customers did not upgrade after the trial plans, 
providing some null values in next_date column. 
So, we use the COALESCE function to remove these null values and replace them by a default date. 
In this case, the default date is the last date in 2020 which is 2020-12-31.
*/

with join_date as (
select s.customer_id, s.plan_id, s.start_date, p.plan_name,
lead(s.start_date, 1) over(partition by s.customer_id order by s.start_date, s.plan_id) as next_date, 
p.price as amount 
from subscriptions s
join plans p
on s.plan_id = p.plan_id 
where s.start_date <= '2020-12-31' and p.plan_name not in ('trial', 'churn')
), 
join_table as 
(select customer_id, plan_id, plan_name, start_date, coalesce(next_date, '2020-12-31') as next_date, 
amount 
from join_date
)
select * from join_table;

/* 
From the table, we can see that the difference between one start_date and another for a customer is more than one month 
(for exmaple, customer with id 7. The difference between the two dates is 3 months). 
This puts us in a situation where we break this down by a month interval to get the monthly subscription 
(i.e next start_date) of customers who are on monthly subscriptions. 
So we write a RECURSIVE query that crates new rows for these customers.

While we want to create new rows for our customers, we also need to create a base case where the rows will not exceed the date in the next_date for each customer. 
This why we needed the next_date column.

*/ 

with recursive join_table as(
select s.customer_id, s.plan_id, s.start_date, p.plan_name,
lead(s.start_date, 1) over(partition by s.customer_id order by s.start_date, s.plan_id) as next_date, 
p.price as amount 
from subscriptions s
join plans p
on s.plan_id = p.plan_id 
where s.start_date <= '2020-12-31' and p.plan_name not in ('trial', 'churn')
), 
join_table1 as (
 select customer_id, plan_id, plan_name, start_date, coalesce(next_date, '2020-12-31') as next_date, 
amount 
from join_table), 
join_table2 as 
( select customer_id, plan_id, plan_name, start_date, next_date, amount 
from join_table1

union all 

SELECT customer_id, plan_id, plan_name, 
    DATE(start_date + INTERVAL 1 MONTH) start_date, 
    next_date, amount FROM join_table2
  WHERE next_date > DATE ((start_date + INTERVAL 1 MONTH))
   AND plan_name != 'pro annual'
)
SELECT * FROM join_table2
ORDER BY customer_id, start_date;


/* 

The last thing we want to do is to create a payments_2020 table and get the payment_order for each customer using the template provided in the payments_order_table template.

Remember that when a customer upgrades from basic to monthly or pro plans, their payments are reduced by the current paid amount in that month and start immediately. Also, upgrades from pro monthly to pro annual are paid at the end of the current billing period and also
starts at the end of the month period.

So, we need to RANK the payment_order of each customer.
*/

CREATE TABLE  payments_2020 AS
WITH RECURSIVE join_table AS (
 SELECT s.customer_id, s.plan_id, p.plan_name, s.start_date, 
   LEAD (s.start_date, 1) OVER (PARTITION BY s.customer_id 
       ORDER BY s.start_date, s.plan_id) next_date,
   p.price AS amount
  FROM subscriptions s
  JOIN plans p 
  ON s.plan_id = p.plan_id
  WHERE start_date <= '20201231'
  AND plan_name NOT IN ('trial', 'churn')
),
join_table1 AS (
 SELECT customer_id, plan_id, plan_name, start_date, 
   COALESCE (next_date, '20201231') next_date, amount
 FROM join_table
),
join_table2 AS (
  SELECT customer_id, plan_id, plan_name, start_date, next_date, 
    amount FROM join_table1

  UNION ALL

  SELECT customer_id, plan_id, plan_name, 
    DATE((start_date + INTERVAL 1 MONTH)) start_date, 
    next_date, amount FROM join_table2
  WHERE next_date > DATE ((start_date + INTERVAL 1 MONTH))
   AND plan_name != 'pro annual'
),
join_table3 AS (
 SELECT *, 
   LAG(plan_id, 1) OVER (PARTITION by customer_id ORDER BY start_date) 
    AS last_payment_plan,
   LAG(amount, 1) OVER(PARTITION BY customer_id ORDER BY start_date) 
    AS last_amount_paid,
   RANK() OVER(PARTITION BY customer_id ORDER BY start_date) AS payment_order
 FROM join_table2
 ORDER BY customer_id, start_date
)
SELECT customer_id, plan_id, plan_name, start_date AS payment_date, 
 (CASE 
   WHEN plan_id IN (2, 3) AND last_payment_plan = 1 
    THEN amount - last_amount_paid
   ELSE amount
 END) AS amount, payment_order
FROM join_table3;

select * from subscriptions;
select * from plans;

select * from payments_2020;


