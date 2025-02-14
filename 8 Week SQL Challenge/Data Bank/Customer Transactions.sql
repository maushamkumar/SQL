use `sql challenge`;

-- 1. What is the unique count and total amount for each transaction type?
select 
	txn_type, 
    count(customer_id) as transaction_count, 
    sum(txn_amount) as total_amount 
from customer_transactions
group by txn_type;

-- 2. What is the average total historical deposit counts and amounts for all customers?

with deposite as (
select 
	customer_id, 
    count(customer_id) as txn_count, 
    avg(txn_amount) as avg_amount
from customer_transactions
where txn_type = 'deposit' 
group by customer_id

) 
select 
	round(avg(txn_count)) as avg_deposit_count, 
    round(avg(avg_amount)) as avg_deposit_amt
    from deposite;
    
    
-- 3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

/* 
First, create a CTE called monthly_transactions to determine the count of deposit, purchase and withdrawal for each customer categorised by month using CASE statement and SUM().

In the main query, select the mth column and count the number of unique customers where:

deposit_count is greater than 1, indicating more than one deposit (deposit_count > 1).
Either purchase_count is greater than or equal to 1 (purchase_count >= 1) OR withdrawal_count is greater than or equal to 1 (withdrawal_count >= 1).

*/ 

with monthly_transactions as (
select 
	customer_id, 
    month(txn_date) as mth, 
    sum(case when txn_type = 'deposit' then 0 else 1 end) as deposit_count, 
    sum(case when txn_type = 'purchase' then 0 else 1 end) as purcahse_count, 
    sum(case when txn_type = 'withdrawal' then 1 else 0 end ) as withdrawal_count 
    from customer_transactions 
    group by customer_id, month(txn_date)

) select mth, 
	count(distinct customer_id) as customer_count
from monthly_transactions
where deposit_count > 1 and (purcahse_count>= 1 or withdrawal_count >= 1) 
group by mth 
order by mth;

-- 4. What is the closing balance for each customer at the end of the month?
/* 
The key aspect to understanding the solution is to build up the tabele and run the CTEs cumulatively (run CTE 1 first, then run CTE 1 & 2, and so on). 
This approach allows for a better understanding of why specific columns were created or how the information in the tables progressed.
*/ 

-- CTE 1 - Identify transaction amount as an inflow (+) or outflow (-)
WITH monthly_balances_cte AS (
  SELECT 
    customer_id, 
    LAST_DAY(txn_date) AS closing_month,  -- MySQL equivalent of finding the last day of the month
    SUM(CASE 
      WHEN txn_type IN ('withdrawal', 'purchase') THEN -txn_amount
      ELSE txn_amount 
    END) AS transaction_balance
  FROM customer_transactions
  GROUP BY 
    customer_id, closing_month
)

-- CTE 2 - Generate a series of last days of the month for each customer
, monthend_series_cte AS (
  SELECT DISTINCT customer_id, 
    LAST_DAY(DATE_ADD('2020-01-31', INTERVAL seq MONTH)) AS ending_month
  FROM customer_transactions
  JOIN (
    SELECT 0 AS seq UNION ALL 
    SELECT 1 UNION ALL 
    SELECT 2 UNION ALL 
    SELECT 3
  ) AS series
)

-- CTE 3 - Calculate total monthly change and ending balance for each month
, monthly_changes_cte AS (
  SELECT 
    m.customer_id, 
    m.ending_month,
    COALESCE(SUM(b.transaction_balance), 0) AS total_monthly_change,
    COALESCE(SUM(SUM(b.transaction_balance)) OVER (
      PARTITION BY m.customer_id 
      ORDER BY m.ending_month
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 0) AS ending_balance
  FROM monthend_series_cte m
  LEFT JOIN monthly_balances_cte b
    ON m.ending_month = b.closing_month
    AND m.customer_id = b.customer_id
  GROUP BY m.customer_id, m.ending_month
)

-- Final query: Display the output of customer monthly statement with the ending balances
SELECT 
  customer_id, 
  ending_month, 
  COALESCE(total_monthly_change, 0) AS total_monthly_change, 
  MIN(ending_balance) AS ending_balance
FROM monthly_changes_cte
GROUP BY 
  customer_id, ending_month, total_monthly_change
ORDER BY 
  customer_id, ending_month;


-- 5. What is the percentage of customers who increase their closing balance by more than 5%?
-- Create Temp Table #1: customer_monthly_balances
CREATE TEMPORARY TABLE customer_monthly_balances (
  customer_id INT,
  ending_month DATE,
  total_monthly_change DECIMAL(18,2),
  ending_balance DECIMAL(18,2)
);

-- Insert data into customer_monthly_balances
INSERT INTO customer_monthly_balances
WITH monthly_balances_cte AS (
  SELECT 
    customer_id, 
    LAST_DAY(txn_date) AS closing_month,  -- MySQL equivalent of DATE_TRUNC + INTERVAL
    SUM(CASE 
      WHEN txn_type IN ('withdrawal', 'purchase') THEN -txn_amount
      ELSE txn_amount 
    END) AS transaction_balance
  FROM customer_transactions
  GROUP BY 
    customer_id, closing_month
), monthend_series_cte AS (
  SELECT DISTINCT customer_id, 
    LAST_DAY(DATE_ADD('2020-01-31', INTERVAL seq MONTH)) AS ending_month
  FROM customer_transactions
  JOIN (
    SELECT 0 AS seq UNION ALL 
    SELECT 1 UNION ALL 
    SELECT 2 UNION ALL 
    SELECT 3
  ) AS series
), monthly_changes_cte AS (
  SELECT 
    m.customer_id, 
    m.ending_month,
    COALESCE(SUM(b.transaction_balance), 0) AS total_monthly_change,
    COALESCE(SUM(SUM(b.transaction_balance)) OVER (
      PARTITION BY m.customer_id 
      ORDER BY m.ending_month
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 0) AS ending_balance
  FROM monthend_series_cte m
  LEFT JOIN monthly_balances_cte b
    ON m.ending_month = b.closing_month
    AND m.customer_id = b.customer_id
  GROUP BY m.customer_id, m.ending_month
)

SELECT 
  customer_id, 
  ending_month, 
  total_monthly_change, 
  MIN(ending_balance) AS ending_balance
FROM monthly_changes_cte
GROUP BY 
  customer_id, ending_month, total_monthly_change
ORDER BY 
  customer_id, ending_month;

-- Create Temp Table #2: ranked_monthly_balances
CREATE TEMPORARY TABLE ranked_monthly_balances (
  customer_id INT,
  ending_month DATE,
  ending_balance DECIMAL(18,2),
  sequence INT
);

-- Insert data into ranked_monthly_balances
INSERT INTO ranked_monthly_balances
SELECT 
  customer_id, 
  ending_month, 
  ending_balance,
  ROW_NUMBER() OVER (
    PARTITION BY customer_id 
    ORDER BY ending_month
  ) AS sequence
FROM customer_monthly_balances;

select * from customer_monthly_balances;
