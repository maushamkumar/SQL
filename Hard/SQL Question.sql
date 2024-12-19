use Sample_Table;

CREATE TABLE Worker (
	WORKER_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	FIRST_NAME CHAR(25),
	LAST_NAME CHAR(25),
	SALARY INT(15),
	JOINING_DATE DATETIME,
	DEPARTMENT CHAR(25)
);

INSERT INTO Worker 
	(WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT) VALUES
		(001, 'Monika', 'Arora', 100000, '21-02-20 09.00.00', 'HR'),
		(002, 'Niharika', 'Verma', 80000, '21-06-11 09.00.00', 'Admin'),
		(003, 'Vishal', 'Singhal', 300000, '21-02-20 09.00.00', 'HR'),
		(004, 'Amitabh', 'Singh', 500000, '21-02-20 09.00.00', 'Admin'),
		(005, 'Vivek', 'Bhati', 500000, '21-06-11 09.00.00', 'Admin'),
		(006, 'Vipul', 'Diwan', 200000, '21-06-11 09.00.00', 'Account'),
		(007, 'Satish', 'Kumar', 75000, '21-01-20 09.00.00', 'Account'),
		(008, 'Geetika', 'Chauhan', 90000, '21-04-11 09.00.00', 'Admin');
        
select * from Worker;

CREATE TABLE Bonus (
	WORKER_REF_ID INT,
	BONUS_AMOUNT INT(10),
	BONUS_DATE DATETIME,
	FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);

INSERT INTO Bonus 
	(WORKER_REF_ID, BONUS_AMOUNT, BONUS_DATE) VALUES
		(001, 5000, '23-02-20'),
		(002, 3000, '23-06-11'),
		(003, 4000, '23-02-20'),
		(001, 4500, '23-02-20'),
		(002, 3500, '23-06-11');

CREATE TABLE Title (
	WORKER_REF_ID INT,
	WORKER_TITLE CHAR(25),
	AFFECTED_FROM DATETIME,
	FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);

INSERT INTO Title 
	(WORKER_REF_ID, WORKER_TITLE, AFFECTED_FROM) VALUES
 (001, 'Manager', '2023-02-20 00:00:00'),
 (002, 'Executive', '2023-06-11 00:00:00'),
 (008, 'Executive', '2023-06-11 00:00:00'),
 (005, 'Manager', '2023-06-11 00:00:00'),
 (004, 'Asst. Manager', '2023-06-11 00:00:00'),
 (007, 'Executive', '2023-06-11 00:00:00'),
 (006, 'Lead', '2023-06-11 00:00:00'),
 (003, 'Lead', '2023-06-11 00:00:00');
 
-- Write an SQl query to fetch "FiRST_NAME" from the Worker table using the alias name <WORKER_NAME>
select * from Worker;
select FIRST_NAME as WORKER_NAME from Worker;

-- Write an SQL Query to fetch "FIRST_NAME" from the worker table in upper case 

select upper(FIRST_NAME) from Worker;

-- Write an SQL query to fetch unique valeus of DEPARTMENT from the worker table;
select distinct(DEPARTMENT) from Worker;

-- Write an SQL query to print the first three characters of FIRST_NAME from the worker table
select substring(FIRST_NAME, 1, 3) from Worker;

select substring(FIRST_NAME, 3,3) from Worker;
-- Write an SQL query to print the first three name of FIRST_NAME from the worker table 
select FIRST_NAME from Worker limit 1,3;

-- Write an SQL query to find the position of the alphabet ('a') in the first name column 'Amitabh' from the worker table.
select instr(FIRST_NAME, Binary 'a') from Worker where FIRST_NAME = 'Amitabh';

-- write an SQL query to print the FIRST_NAME from the worker table after removing white spaces from the right side.
select rtrim(FIRST_NAME) from worker;

-- Write an SQL query to print the DEPARTMENT from the worker table after removing white spaces from the left side 
select ltrim(DEPARTMENT) from Worker;

-- fetches the unique vlaues of DEPARTMENT from the worker table and prints its length.
select distinct(DEPARTMENT) from Worker;

-- Print the FIRST_NAME from the worker table after replacing 'a' with 'A'
select replace(FIRST_NAME, 'a', 'A') from Worker;

-- print the LAST_NAME from the worker table after replacing 'm' with 'M'
select replace(LAST_NAME, 'm', 'M') from Worker;

-- Print the FIRST_NAME and LAST_NAME from the worker table into a single column COMPLETE_NAME A space char should separate them 
SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) as COMPLETE_NAME FROM Worker;

-- Print all Worker details from the Worker table order by FIRST_NAME Ascending.
select * from Worker order by FIRST_NAME asc;

-- Print all  Worker details from the Worker table order by FIRST_NAME Ascending and DEPARTMENT Descending.
select * from Worker order by FIRST_NAME asc , DEPARTMENT desc;

-- Print details for Workers with the first names "Vipul" and "Satish" from the Worker table.
select * from Worker where FIRST_NAME in("Vipul", "Satish");

-- Print details of Workers excluding first names, “Vipul” and “Satish” from the Worker table.
select * from Worker where FIRST_NAME not in("Vipul", "Satish");

-- Print details of Workers with DEPARTMENT name as "Admin"
select * from Worker where DEPARTMENT in ("Admin%");
select * from Worker where DEPARTMENT like "Admin%";
select * from Worker where DEPARTMENT =  "Admin";

-- Print details of the Workers whose FIRST_NAME contains 'a'
select * from Worker where FIRST_NAME like '%a%';

-- Print details of the WOrkers whose FIRST_NAME ends with 'a'
select * from Worker where FIRST_NAME like '%a';

-- Print details of the Workes whose FIRST_NAME Satart with 'a'
select * from Worker where FIRST_NAME like 'a%';

-- Print details of the Workers whose FIRST_NAME ends with 'h' and contains six alphabets.
select * from Worker where FIRST_NAME like '_____h';

-- Print details of the Workers whose SALARY lies between 100000 and 500000.
select * from Worker where SALARY between 100000 and 500000;

-- Print details of the workers who joined in fed 2021.
select * from Worker where year(JOINING_DATE) = 2021 and month(JOINING_DATE) = 2;

-- Fetch the count of employees working in the department 'Admin'
select count(*) from Worker where DEPARTMENT = 'Admin';

-- Write an SQL query to fetch worker names with salaries >= 50000 and <= 100000
select Concat(FIRST_NAME, ' ', LAST_NAME) as FULL_NAME, SALARY 
from Worker 
where WORKER_ID in 
(select WORKER_ID from worker 
where Salary BETWEEN 50000 AND 100000);

SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) AS FULL_NAME, SALARY
FROM Worker
WHERE SALARY >= 50000 AND SALARY <= 100000;

-- fetch the number of workers for each department in descening order.
select DEPARTMENT, count(*) 
from Worker 
group by DEPARTMENT 
order by count(*);

select DEPARTMENT, count(WORKER_ID) No_Of_Workers
from Worker
group by DEPARTMENT
order by No_Of_Workers;

-- Print details of the Workers who are also managers
select distinct w.FIRST_NAME, t.WORKER_TITLE
from Worker w
join Title t
on w.WORKER_ID = t.WORKER_REF_ID
and t.WORKER_TITLE in ('Manager');

-- Print details of the Workers who are also Lead
select distinct w.FIRST_NAME, t.WORKER_TITLE
from Worker w 
join Title t
on  w.WORKER_ID = t.WORKER_REF_ID
and t.WORKER_TITLE in ('Lead');

-- Fetch duplicate records having matching data in some fields of a table 
select WORKER_TITLE, AFFECTED_FROM, count(*)
from title
group by WORKER_TITLE, AFFECTED_FROM
having count(*) > 1;

-- Query to show only odd rows from a table 
select * from Worker where MOD(WORKER_ID, 2)<> 0;

-- Write a query to show only even rows from a table 
select * from Worker where mod(WORKER_ID, 2) = 0;

-- Create a with same features 
CREATE TABLE WorkerClone AS SELECT * FROM Worker;


-- Write an query to clone a new table from another table;
CREATE TABLE WorkerClone AS SELECT * FROM Worker;

select * into WorkerClone from Worker where 1 = 0;

CREATE TABLE WorkerClone AS SELECT * FROM Worker WHERE 1 = 0;

CREATE TABLE WorkerClone LIKE Worker;

-- Write an query to clone a new table with specific feature
create table mausham as select FIRST_NAME, DEPARTMENT from Worker;

drop table WorkerClone;
select * from WorkerClone;
select * from mausham;

-- Write an SQL quary to fetch intersecting records of two tables.
(select * from Worker)
union 
(select * from WorkerClone);

SELECT * FROM Worker WHERE EXISTS (
    SELECT * FROM WorkerClone WHERE WorkerClone.id = Worker.id
);

-- Write an SQL query to show the current data and time 
SELECT CURRENT_TIMESTAMP;
-- This query will show current date
select curdate();

-- This query will show current date and time
select now();

-- Write an SQL query to show the top n (say 10) records of a table.
select * from Worker order by Salary desc limit 10;

SELECT * FROM (SELECT * FROM Worker WHERE WORKER_ID <= 5 ORDER BY Salary DESC) AS subquery;

-- Write an SQL query to determine the nth (say n=5) highest salary from a table.
select Salary from Worker order by Salary desc limit 1, 5;

-- Write an SQL query to determine the 5th highest salary without using the top or limit method 

select Salary 
from Worker w1
where 4 = (select count(distinct(w2.Salary))
from Worker w2
where w2.Salary >= w1.Salary
);


-- Write an SQL query to fetch the list of employees with the same salary
select * from 
Worker w, Worker w1
where w.Salary = w1.Salary
and w.WORKER_ID = w1.WORKER_ID;

-- Write an SQL query to show the second-highest salary from a table
select * from Worker order by Salary desc limit 2, 1;

SELECT DISTINCT Salary 
FROM Worker w1
WHERE 1 = (
    SELECT COUNT(DISTINCT w2.Salary)
    FROM Worker w2
    WHERE w2.Salary > w1.Salary
);

select max(Salary) from Worker
where Salary not in (select max(Salary) from Worker);

-- Write an SQL query to show one row twice in the restult from a table 

select w.FIRST_NAME, w.DEPARTMENT 
from Worker w, Worker w1
where w.DEPARTMENT=w1.DEPARTMENT and w.DEPARTMENT='HR';

select FIRST_NAME, DEPARTMENT 
from Worker w where w.DEPARTMENT = 'HR'
union all
select FIRST_NAME, DEPARTMENT 
from Worker w where w.DEPARTMENT = 'HR';

-- Write and SQL query to fetch intersecting records of two tables.
(SELECT * FROM Worker)
union
(SELECT * FROM WorkerClone);

-- Write a query to fetch the first 50% of records from a table.
select * from Worker where WORKER_ID <= (select count(WORKER_ID)/2 from Worker);

-- Write an SQL query to fetch the departments that have less then than five people in them.
SELECT DEPARTMENT, COUNT(WORKER_ID) as 'Number of Workers' 
FROM Worker 
GROUP BY DEPARTMENT 
HAVING COUNT(WORKER_ID) < 5;

-- Write an SQL query to show all departments along with the number of people in there 

select DEPARTMENT, COUNT(WORKER_ID) as Number_of_people
from Worker 
group by DEPARTMENT 
having COUNT(WORKER_ID)
;

select DEPARTMENT, COUNT(WORKER_ID) as Number_of_people
from Worker 
group by DEPARTMENT 
;

-- Write an SQL query to show the last record from a table
select * from Worker where WORKER_ID = (select max(WORKER_ID) from Worker);
-- This is little bit expensive
select * from Worker order by WORKER_ID desc limit 1;

-- Write an SQL query to fetch the first row of a table
select * from Worker where WORKER_ID = (select min(WORKER_ID) from Worker);

-- This is little bit expensive
select * from Worker order by WORKER_ID asc limit 1;

-- Write an SQL query to fetch the last five records from a table 
SELECT * FROM Worker WHERE WORKER_ID >= (SELECT MAX(WORKER_ID) - 4 FROM Worker);

SELECT * FROM Worker ORDER BY WORKER_ID DESC LIMIT 5;

select * from Worker where WORKER_ID <= 5
union
select * from (select * from Worker w order by w.WORKER_ID desc) as w1 
where w1.WORKER_ID <= 5;

-- Write an SQL query to print the names of employees having the highest salary in each department




