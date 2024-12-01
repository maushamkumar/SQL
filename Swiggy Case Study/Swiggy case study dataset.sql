use swiggy;

create table users (
user_id int, 
name varchar(50), 
email varchar(100), 
password varchar(50)
);

insert into users values 
(1, 'Mausham', 'maushahroy@gmail.com', 'igtiutay'), 
(2, 'Nitish', 'nitish@gmail.com', 'p252h'), 
(3, 'Vartika', 'vartika@gmail.com', '9hu7j'), 
(4, 'Ankit', 'ankit@gmail.com', 'lkko3'), 
(5, 'Neha', 'neha@gmail.com', '3i7qm'), 
(6, 'Anupama', 'anupama@gmail.com', '46dw2'), 
(7, 'Rishabh', 'rishabh@gmail.com', '4sw123');

select * from users;

create table food(
f_id int, 
f_name varchar(50), 
type varchar(50));

insert into food values 
(1, 'Non-veg Pizza', 'Non-veg'), 
(2, 'Veg Pizza', 'Veg'), 
(3, 'Choco Lava cake', 'Non-veg'), 
(4, 'Chicken Wings', 'Non-veg'), 
(5, 'Chicken Popcorn', 'Non-veg'), 
(6, 'Rice Meal', 'Veg'), 
(7, 'Roti Meal', 'Veg'),
(8, 'Masala Dosa', 'Veg'),  
(9, 'Rava idli', 'veg'), 
(10, 'Schezwan Noodles', 'veg'), 
(11, 'Veg Manchurian', 'veg');

select * from food;

truncate food;


create table restaurants(
    r_id int, 
    r_name varchar(50), 
    cuisine varchar(50)
);

insert into restaurants values
    (1, 'dominos', 'Italian'), 
    (2, 'Kfc', 'American'), 
    (3, 'box8', 'North Indian'), 
    (4, 'Dosa Piaza', 'South Indian'), 
    (5, 'China Town', 'Chinese');
    
drop table restaurants;
select * from  restaurants;

create table orders (
    order_id int, 
    user_id int, 
    r_id int, 
    amount int, 
    date date
);

insert into orders values
    (1001, 1, 1, 550, '2024-05-10'), 
    (1002, 1, 2, 415, '2024-05-26'), 
    (1003, 1, 3, 240, '2024-06-15'),
    (1004, 1, 3, 240, '2024-06-29'),
    (1005, 1, 3, 220, '2024-07-10'),
    (1006, 2, 1, 950, '2024-06-10'),
    (1007, 2, 2, 530, '2024-06-23'),
    (1008, 2, 3, 240, '2024-07-07'),
    (1009, 2, 4, 300, '2024-07-17'),
    (1010, 2, 5, 650, '2024-07-31'),
    (1011, 3, 1, 450, '2024-05-10'),
    (1012, 3, 4, 180, '2024-05-20'),
    (1013, 3, 2, 230, '2024-05-30'),
    (1014, 3, 2, 230, '2024-06-11'),
    (1015, 3, 2, 230, '2024-06-22'),
    (1016, 4, 4, 300, '2024-05-15'),
    (1017, 4, 4, 300, '2024-05-30'),
    (1018, 4, 4, 400, '2024-06-15'),
    (1019, 4, 5, 400, '2024-06-30'),
    (1020, 4, 5, 400, '2024-07-15'),
    (1021, 5, 1, 550, '2024-07-01'),
    (1022, 5, 1, 550, '2024-07-08'),
    (1023, 5, 2, 645, '2024-07-15'),
    (1024, 5, 2, 645, '2024-07-21'),
    (1025, 5, 2, 645, '2024-07-28');


select * from orders;

CREATE TABLE order_details (
    id INT PRIMARY KEY,
    order_id INT,
    f_id INT
);

INSERT INTO order_details VALUES
(1, 1001, 1),
(2, 1001, 3),
(3, 1002, 4),
(4, 1002, 3),
(5, 1003, 6),
(6, 1003, 3),
(7, 1004, 6),
(8, 1004, 3),
(9, 1005, 7),
(10, 1005, 3),
(11, 1006, 1),
(12, 1006, 2),
(13, 1006, 3),
(14, 1007, 4),
(15, 1007, 3),
(16, 1008, 6),
(17, 1008, 3),
(18, 1009, 8),
(19, 1009, 9),
(20, 1010, 10),
(21, 1010, 11),
(22, 1010, 6),
(23, 1011, 1),
(24, 1012, 8),
(25, 1013, 4),
(26, 1014, 4),
(27, 1015, 4),
(28, 1016, 8),
(29, 1016, 9),
(30, 1017, 8),
(31, 1017, 9),
(32, 1018, 10),
(33, 1018, 11),
(34, 1019, 10),
(35, 1019, 11),
(36, 1020, 10),
(37, 1020, 11),
(38, 1021, 1),
(39, 1021, 3),
(40, 1022, 1),
(41, 1022, 3),
(42, 1023, 3),
(43, 1023, 4),
(44, 1023, 5),
(45, 1024, 3),
(46, 1024, 4),
(47, 1024, 5),
(48, 1025, 3),
(49, 1025, 4),
(50, 1025, 5);

select * from order_details;

CREATE TABLE menu (
    menu_id INT PRIMARY KEY,
    r_id INT,
    f_id INT,
    price INT
);

INSERT INTO menu (menu_id, r_id, f_id, price) VALUES
(1, 1, 1, 450),
(2, 1, 2, 400),
(3, 1, 3, 100),
(4, 2, 3, 115),
(5, 2, 4, 230),
(6, 2, 5, 300),
(7, 3, 3, 80),
(8, 3, 6, 160),
(9, 3, 7, 140),
(10, 4, 6, 230),
(11, 4, 8, 180),
(12, 4, 9, 120),
(13, 5, 6, 250),
(14, 5, 10, 220),
(15, 5, 11, 180);

select * from menu;

CREATE TABLE partners (
    partner_id INT PRIMARY KEY,
    partner_name VARCHAR(50)
);


INSERT INTO partners (partner_id, partner_name) VALUES
(1, 'Suresh'),
(2, 'Amit'),
(3, 'Lokesh'),
(4, 'Kartik'),
(5, 'Gyandeep');


select * from partners;

drop table order_details;
