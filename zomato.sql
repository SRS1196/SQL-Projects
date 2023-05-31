CREATE DATABASE Zomato;
use zomato;
drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup (userid, gold_signup_date) 
VALUES (1, '2017-09-22'), (3, '2017-04-21');

SELECT * FROM goldusers_signup;

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users (userid, signup_date) 
VALUES (1, '2014-09-02'), (2, '2015-01-15'), (3, '2014-04-11');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales (userid, created_date, product_id) 
VALUES 
(1, '2017-04-19', 2),
(3, '2019-12-18', 1),
(2, '2020-07-20', 3),
(1, '2019-10-23', 2),
(1, '2018-03-19', 3),
(3, '2016-12-20', 2),
(1, '2016-11-09', 1),
(1, '2016-05-20', 3),
(2, '2017-09-24', 1),
(1, '2017-03-11', 2),
(1, '2016-03-11', 1),
(3, '2016-11-10', 1),
(3, '2017-12-07', 2),
(3, '2016-12-15', 2),
(2, '2017-11-08', 2),
(2, '2018-09-10', 3);

drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

### 1 .  What is the total amount each costumer spent on zomato ?
select a.userid,sum(b.price) total_amt_spent from sales a inner join product b on a.product_id=b.product_id
group by a.userid

### 2 . How many days has each customer visited zomato ?
SELECT userid, COUNT(DISTINCT created_date) AS days_visited
FROM sales
GROUP BY userid;

### 3. What was the first product purchased by each customer ?
select * from
(SELECT *,rank() over(partition by userid order by created_date ) rnk from sales ) a where rnk =1

### 4. What is the most purchased item on the menu and how many times was it purchased by all the customers ?

SELECT p.product_name, COUNT(*) AS purchase_count
FROM sales s
JOIN product p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY purchase_count DESC
LIMIT 1;

Select userid, count(product_id) cnt from sales where product_id = 
(select top 1 product_id from sales group by product_id order by count(product_id)desc)
group by userid

### 5. Which item was the most popular for each customer ?

SELECT *,
       RANK() OVER (PARTITION BY userid ORDER BY cnt DESC) AS rnk
FROM
  (SELECT userid,
          product_id,
          COUNT(product_id) AS cnt
   FROM sales
   GROUP BY userid, product_id) subquery;