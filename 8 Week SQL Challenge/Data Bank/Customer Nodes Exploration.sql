use `sql challenge`;

select * from regions;
select * from customer_nodes;
select * from customer_transactions;

use `sql challenge`;

select * from regions;
select * from customer_nodes;
select * from customer_transactions;

-- 1. How many unique nodes are there on the Data Bank System?
select count(distinct node_id) as unique_nodes 
from customer_nodes;

-- 2. What is the number of nodes per region?
select r.region_name, 
count(distinct c.node_id) as node_count
from regions r 
join customer_nodes as c 
on r.region_id = c.region_id 
group by  r.region_name;


-- 3. How many Customers are allocated to each region?
select 
	region_id, 
    count(customer_id) as customer_count
    from customer_nodes
    group by region_id 
    order by region_id;
    
    
-- 4. How many day's average are customers reallocated to a different node?

with node_days as 
(select 
	customer_id, 
    node_id, 
    end_date - start_date as days_in_node 
    from customer_nodes 
    where end_date != '9999-12-31'
    group by customer_id, node_id, start_date, end_date

), 
total_node_days as (
	select 
    customer_id, 
    node_id, 
    sum(days_in_node) as total_days_in_node 
from node_days 
group by customer_id, node_id

)select round(avg(total_days_in_node)) as avg_node_reallocation_days
 from total_node_days;
 
 
WITH node_days AS (
  SELECT 
    customer_id, 
    node_id,
    SUM(DATEDIFF(end_date, start_date)) AS days_in_node
  FROM customer_nodes
  WHERE end_date != '9999-12-31'
  GROUP BY customer_id, node_id
) 
SELECT ROUND(AVG(days_in_node)) AS avg_node_reallocation_days
FROM node_days;

-- 5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
WITH node_days AS (
  SELECT 
    customer_id, 
    region_id, 
    SUM(DATEDIFF(end_date, start_date)) AS days_in_node
  FROM customer_nodes
  WHERE end_date != '9999-12-31'
  GROUP BY customer_id, region_id, node_id
),
percentiles AS (
  SELECT 
    region_id,
    days_in_node,
    PERCENT_RANK() OVER (PARTITION BY region_id ORDER BY days_in_node) AS percentile_rank
  FROM node_days
)
SELECT 
    region_id,
    MAX(CASE WHEN percentile_rank <= 0.80 THEN days_in_node END) AS "80th_percentile",
    MAX(CASE WHEN percentile_rank <= 0.95 THEN days_in_node END) AS "95th_percentile"
FROM percentiles
GROUP BY region_id;
