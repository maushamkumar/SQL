-- Customer Behavior Through Database Analysis
-- This database consisted of five tables 
-- Sales, Product, Goldusers_Singup, Users, and User_name Each table unique information about the customers and Products sold on the website 

-- The sales table provided details about each Sale, Including the data of the sale, the product sold, the price and the user who made the purchase. 
-- By Analyzing this table, we were able to identify the top-selling produts and the most active users on the websites. 

-- The product table contained infromation about each product sold on the website, including the Produdt ID, Product Name, and Price of the Product. 
-- Using the is table, we were able to ifentify the prices for each product and compare them to determine which products are more expensive and which are less expensive. 

-- The goldusers_singup table contained data bout customer who signed up for the website's premium membership program. 
-- we were able to use this table to identify the demographics of customers who were most likely to sign up for the program and which benefits of the program were most appealing to custoemrs. 

-- The user table provided information about each customer who created an account on the webstie. including their name, signup date. 
-- By analyzing this table, we were able to identify trends in customer demograpics.  

-- The user_name table contains information about each user's UserID and User_Name. We utilized this table to link with other tables. 
-- Specifically, the includes the UserID and the corresponding Name of the Users. 
-- The UserID can be used as a linking factor to connect with other tables in the database. The names column provides the name of each user correspondign to theier UserID. 

-- By analyzing these table we can answer these kind of question 
-- Top selling products, the most active users, the demographics of customers who were most likely to sign up for the premium memebership program. 


-- Problem Statement 
-- I want to use the data to answer a few questions about the customers, especially about their visiting pattern 
-- How much money they've spent and also which menu items are their favourite. 
-- Having this deeper conncection with his customer will help him deliver a better and more personalised experience for his loyal custoemrs. 

/* Based on the insights gained from the data, the client plans to decide whether to expand the existing customer loyalty program. Additionally, 
they require assistance in generating some basic datasets so that their team can easily inspect the data without the need for using SQL.
*/

use Zomato;
-- Create the Users table
-- Create Tables
CREATE TABLE Users (
    userid INT PRIMARY KEY,
    signup_date DATE
);

CREATE TABLE User_name (
    userid INT PRIMARY KEY,
    Names VARCHAR(50),
    FOREIGN KEY (userid) REFERENCES Users(userid)
);

CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

CREATE TABLE Sales (
    userid INT,
    created_date DATE,
    product_id INT,
    FOREIGN KEY (userid) REFERENCES Users(userid),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

CREATE TABLE Golduser_Signup (
    userid INT,
    gold_signup_date DATE,
    FOREIGN KEY (userid) REFERENCES Users(userid)
);

-- Insert data into Users table
INSERT INTO Users (userid, signup_date) VALUES
(1, '2014-09-02'),
(2, '2015-01-15'),
(3, '2014-04-11'),
(4, '2015-11-02'),
(5, '2015-09-08'),
(6, '2014-07-13'),
(7, '2013-04-02'),
(8, '2013-12-15'),
(9, '2016-02-02'),
(10, '2016-02-02');

-- Insert data into User_name table
INSERT INTO User_name (userid, Names) VALUES
(1, 'Anshul'),
(2, 'Rohan'),
(3, 'Shreya'),
(4, 'Priya'),
(5, 'Aryan'),
(6, 'Sara'),
(7, 'Sahil'),
(8, 'Tanvi'),
(9, 'Ritika'),
(10, 'Gaurav');

-- Insert data into Product table
INSERT INTO Product (product_id, product_name, price) VALUES
(1, 'Dal Makhani', 160.00),
(2, 'Shahi Paneer', 170.00),
(3, 'Butter Chicken', 340.00),
(4, 'Aloo Gobi', 150.00),
(5, 'Chole Bhature', 100.00),
(6, 'Fish Curry', 380.00),
(7, 'Chicken Tikka', 300.00),
(8, 'Mutton Biryani', 450.00),
(9, 'Veg Pulao', 200.00),
(10, 'Mango Lassi', 80.00),
(11, 'Gulab Jamun', 90.00);

-- Insert data into Sales table (62 rows of sample data)
INSERT INTO Sales (userid, created_date, product_id) VALUES
-- User 1 purchases
(1, '2017-04-19', 2),
(1, '2019-03-19', 3),
(1, '2019-03-19', 3),
(1, '2018-03-19', 3),
(1, '2016-11-15', 1),
(1, '2016-05-20', 3),
(1, '2017-03-11', 2),
(1, '2016-03-11', 1),

-- User 2 purchases
(2, '2020-07-20', 3),
(2, '2017-09-24', 1),
(2, '2017-11-08', 2),
(2, '2018-09-10', 3),
(2, '2018-03-15', 3),
(2, '2018-04-20', 1),
(2, '2018-05-25', 2),

-- User 3 purchases
(3, '2019-12-18', 1),
(3, '2016-12-20', 2),
(3, '2016-10-10', 1),
(3, '2017-12-07', 2),
(3, '2016-12-15', 1),
(3, '2017-02-15', 3),
(3, '2017-04-15', 2),

-- User 4 purchases
(4, '2019-05-01', 1),
(4, '2020-08-17', 1),
(4, '2019-06-10', 3),
(4, '2019-07-15', 2),
(4, '2019-08-20', 1),
(4, '2019-09-25', 3),

-- User 5 purchases
(5, '2018-11-23', 3),
(5, '2017-05-12', 10),
(5, '2018-12-25', 2),
(5, '2019-01-30', 1),
(5, '2019-02-15', 3),
(5, '2019-03-20', 2),

-- User 6 purchases
(6, '2017-06-30', 9),
(6, '2017-01-27', 4),
(6, '2017-07-15', 3),
(6, '2017-08-20', 2),
(6, '2017-09-25', 1),
(6, '2017-10-30', 3),

-- User 7 purchases
(7, '2018-08-12', 8),
(7, '2014-04-02', 7),
(7, '2018-09-15', 3),
(7, '2018-10-20', 2),
(7, '2018-11-25', 1),
(7, '2018-12-30', 3),

-- User 8 purchases
(8, '2019-03-19', 7),
(8, '2020-12-15', 8),
(8, '2019-04-15', 3),
(8, '2019-05-20', 2),
(8, '2019-06-25', 1),
(8, '2019-07-30', 3),

-- User 9 purchases
(9, '2017-12-04', 6),
(9, '2017-09-08', 6),
(9, '2018-01-15', 3),
(9, '2018-02-20', 2),
(9, '2018-03-25', 1),
(9, '2018-04-30', 3),

-- User 10 purchases
(10, '2018-09-22', 5),
(10, '2018-10-15', 3),
(10, '2018-11-20', 2),
(10, '2018-12-25', 1),
(10, '2019-01-30', 3),
(10, '2019-02-15', 2);

-- Insert data into Golduser_Signup table
INSERT INTO Golduser_Signup (userid, gold_signup_date) VALUES
(1, '2017-09-22'),
(3, '2017-04-21'),
(4, '2019-01-13'),
(5, '2018-08-04'),
(7, '2018-06-17'),
(9, '2019-02-11');

-- Create indexes for better performance
CREATE INDEX idx_sales_userid ON Sales(userid);
CREATE INDEX idx_sales_product_id ON Sales(product_id);
CREATE INDEX idx_sales_created_date ON Sales(created_date);
CREATE INDEX idx_gold_userid ON Golduser_Signup(userid);
CREATE INDEX idx_gold_signup_date ON Golduser_Signup(gold_signup_date);

select *, count(*) from Sales;
select * from Product;
select * from Golduser_Signup;
select * from Users;
select * from User_name;

-- The Sales table consists of 64 rows and 3 columns: 
-- userid, created_date, and Product_id range from 1 to 11, and the user_id ranges from 1 to 10 
-- This table provides information on which user_id has confirmed an order, which product they have purchased and the data on which the order was placed. 

-- The Product 
-- The product talbe provides more information about the products that are being sold in first talbe. it includes 11 rows, each representing a unique product, 
-- with columns for Product ID, Product_name, and price. The product IDs range from 1 to 11 and correspond to the product IDs in the first table. 
-- Each Product has a unique name that describes the dish, such as Dal Makhani, Butter Chicken or Fish Curry. The prices of the products range from 80 to 450
-- With Mango Lassi being the least enpensive and Mutton Biryani being the most expensive. 
-- This information can be used to analyze the sales data in the first table, to determine which products are the most popular and which porduct generate the most revenue. 
-- It can also be used to make decisions about pricing and product offering in the future. 

select * from User_name;
-- This table show a list of userid and corresponding names. There are 10 users in total, each with a unique user ID ranging from 1 to 10. 
-- The names of the users are listed in the column next to their repective user ID. This table could be used to track user information in a database
-- or provide a reference for user indentification in a software system. 

select * from users;
-- This table shows the signup dates for the users in the systems. The date range from 2013 to 2016, indicating that the system has been active for several years. 
-- It also shows that some users signed up on the same day, such as users 10 and 9, and user 7 and 8. This could be an indication that they signed up together, 
-- or that the system was launched on those vehavior, such as how long they have been active on the system and if there are any patterns in signup dates. 

select * from Golduser_Signup;
-- The given table shows the gold_signup_date for a few users, where the user with their repective user IDs have upgraded to gold membership. 
-- Gold membership usually comes iwht additional perks and benefits like exclusive offers, faster shipping, and priority customer support, among others.

-- It can be observed that the gold_signup_date for the users ranges from 2017 to 2019, which indicates that they have been gold members for a while now. 
-- It’s interesting to note that not all users who signed up earlier have upgraded to gold membership, as seen in the case of user ID 2, 
-- who signed up in 2015 but is not a gold member. This could be due to various reasons like personal preference, lack of interest in the offered benefits, 
-- or inability to pay the additional fees for gold membership.
select * from Product;

-- Question 1 
-- What is the total sales revenues generated by each product? 
with revenue as (select s.product_id, p.product_name, count(price) as order_time, sum(price) as revenues 
from product p
join sales s 
on p.product_id = s.product_id
group by s.product_id
order by sum(price) desc) 
select product_name, revenues from revenue;

-- Which 3 Product has the highest sales revenue?
with revenue as (select s.product_id, p.product_name, count(price) as order_time, sum(price) as revenues 
from product p
join sales s 
on p.product_id = s.product_id
group by s.product_id
order by sum(price) desc) 
select product_name, revenues from revenue
limit 3;

-- How many users have signed up for the service and has taken the gold membership?
select count(distinct u.userid) as Free_user, count(distinct g.userid) as Paid_user  from users u 
union all  
golduser_signup g 
on u.userid = g.userid;
select * from users 
union all 
select * from golduser_signup;

SELECT 
    COUNT(DISTINCT u.userid) as Total_users,
    COUNT(DISTINCT g.userid) as Gold_users,
    COUNT(DISTINCT u.userid) - COUNT(DISTINCT g.userid) as Regular_users
FROM users u
LEFT JOIN golduser_signup g ON u.userid = g.userid;

-- What is revenue generated from gold users?
with paid_user as (select * from users u 
inner join golduser_signup g 
on u.userid = g.userid), 
sold_product as (
select * from sales);

select s.userid, p.product_name, sum(price) as revenue from sales s
join product as p 
on s.product_id = p.product_id
group by s.userid, p.product_name;


with cte as (select s.userid, 
	s.created_date, 
    s.product_id, 
    gold_signup_date, 
    p.product_name, price, 
    um.Names,
	case 
		when created_date > gold_signup_date then price  
		when created_date < gold_signup_date then 0 
end as after_gold_member
from sales s 
inner join golduser_signup g 
on s.userid = g.userid
inner join user_name um
on s.userid = um.userid
inner join product as p 
on p.product_id = s.product_id
) 
select userid, Names, sum(after_gold_member) as `Memeber's Amount` 
from cte 
group by userid 
 ;

-- What is total revenue generate from gold users 

with cte as (select s.userid, 
	s.created_date, 
    s.product_id, 
    gold_signup_date, 
    p.product_name, price, 
    um.Names,
	case 
		when created_date > gold_signup_date then price  
		when created_date < gold_signup_date then 0 
end as after_gold_member
from sales s 
inner join golduser_signup g 
on s.userid = g.userid
inner join user_name um
on s.userid = um.userid
inner join product as p 
on p.product_id = s.product_id
) 
select sum(after_gold_member) as `Memeber's Amount` 
from cte 
;

-- Which users has been a gold user for the How much of time?
select userid, concat(floor(datediff(current_date(), gold_signup_date)/365), 'Year', '&', 
mod(floor(datediff(current_date(), gold_signup_date)/30.44), 12), 'Months') as period 
from golduser_signup;

-- What is the most popular product among gold users?
select s.product_id, product_name, count(*) as most_popular_product 
from sales s 
left join golduser_signup as gs 
on s.userid = gs.userid
inner join product as p on p.product_id = s.product_id 
where gs.userid is not null 
group by product_id 
order by product_id, most_popular_product desc 
limit 3;

-- What is the total sales revenue generated in each year? 
select year(created_date)