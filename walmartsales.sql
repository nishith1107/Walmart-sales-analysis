-- create database
create database walmartdata;

-- set the database as default
use walmartdata;

-- create table sales
create table sales(
invoice_id varchar(30) not null primary key,
branch  VARCHAR(5) not null,
city VARCHAR(30) not null,
customer_type VARCHAR(30) not null,
gender VARCHAR(10) not null,
product_line VARCHAR(100) not null,
unit_price DECIMAL(10, 2) not null,
quantity 	INT not null,
VAT FLOAT not null,
total DECIMAL(10, 2) not null,
date DATE not null,
time TIME not null,
payment_method varchar(30) not null,
cogs DECIMAL(10, 2) not null,
gross_margin_percentage FLOAT not null,
gross_income DECIMAL(10, 2) not null,
rating 	FLOAT);

-- add column time_of_day to the sales table
alter table sales
add column time_of_day varchar(10);

-- Turn off safe mode for update command to work
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Or set the following query
SET SQL_SAFE_UPDATES = 0;

-- Update sales
update sales
set time_of_day=(case 
		when `time` between "00:00:00" and "12:00:00" then "morning"
		when `time` between "12:01:00" and "16:00:00" then "afternoon"
		else
			"evening"
		end
	);
    
    -- add column monthname to the sales table
alter table sales
add column monthname varchar(20);

-- update table sales
update sales
set monthname=monthname(date);
    
-- add column dayname to sales
alter table sales
add column dayname varchar(20);

-- update sales
update  sales
set dayname=dayname(date);

-- add column monthname to sales
alter table sales
add column monthname varchar(20);

-- update sales
update sales
set monthname=monthname(date);

-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------
-- How many unique cities does the data have?
select distinct city from sales;

-- In which city is each branch?
select distinct city,
branch from sales;

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

-- How many unique product lines does the data have?
select distinct product_line from sales;

-- which is the popular payment methods?
select 
	payment_method,
	count(payment_method) as popularity
from sales
group by payment_method
order by popularity desc;

-- which is the popular product line?
select 
	product_line,
	count(product_line) as popularity
from sales
group by product_line
order by popularity desc;

-- what is the total sales in each product line?
select
	product_line ,
	sum(total) as qty
   from sales
group by product_line
order by qty desc;

-- what is the total sales in each month?
select 
	monthname as month ,
	sum(total) as total_revenue
from sales
group by month
order by total_revenue;

-- which month had the highest COGS?
select 
	monthname as month,
	sum(cogs) as COGS
from sales
group by month
order by COGS desc
limit 1;

-- which product line had the highest revenue?
select 
	product_line,
	sum(total) as revenue
from sales 
group by product_line
order by revenue
limit 1;

-- which city has the highest revenue?
select 
	city,
	sum(total) as revenue
from sales
group by city
order by revenue;

-- which product line has the highest VAT?
select 
	product_line,
	avg(VAT) as VAT
from sales
group by product_line
order by VAT
LIMIT 1;

/*Fetch each product line and add a column to those product 
line showing "Good", "Bad". Good if its greater than average rating*/

SELECT
	product_line,
	CASE
		WHEN AVG(rating) >= 5 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;


-- list the products sold by branch
select 
	branch,
	sum(quantity) as quantity_sold
from sales
group by branch
having quantity_sold > (select avg(quantity) from sales);

-- what is the most common product line by gender?
select
	gender,
    product_line,
	count(gender) as gender_count
from sales
group by gender,product_line
order by gender_count;

-- what is the average rating for every product line?
select
	product_line,
	round(avg(rating),2) as average_rating
from sales
group by product_line
order by average_rating;

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------
-- what are the types of customers?
select distinct customer_type from sales;

-- what are the different payment methods?
select distinct payment_method from sales;

-- total customers by customer type
select 
	customer_type,
	count(customer_type) as count
from sales
group by customer_type
order by count;

-- Which customer type buys the most?
select 
	customer_type,
	count(*) as count_of_sales
from sales 
group by customer_type
order by count_of_sales desc
limit 1;

-- average spend of different customer type
select 
	customer_type,
	round(avg(total),2) as spend
from sales
group by customer_type
order by spend;

-- What is the count of each gender among the customers?
select 
	gender,
	count(gender) as count
from sales
group by gender
order by count;

-- What is the gender distribution per branch?
SELECT
    gender,
    branch,
    COUNT(gender) AS count
FROM sales
GROUP BY gender, branch
ORDER BY branch, count; 
/*Gender per branch is more or less the same hence, I don't think has
an effect of the sales per branch and other factors.*/

-- what is the average rating for different time of the day?
select 
	time_of_day,
	round(avg(rating),2 )as average_rating
from sales
group by time_of_day
order by average_rating;

-- what is the average rating throughout the week?
SELECT
    dayname,
    ROUND(AVG(rating), 2) AS average_rating
FROM sales
GROUP BY dayname
ORDER BY FIELD(dayname,  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday','Sunday'), average_rating;

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- what is the total sales for different hours in a day?
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- what is the total sales made for different customer type?
select 
	customer_type,
	sum(total) as sales
from sales
group by customer_type
order by sales;

-- what is the average VAT for all cities?
select 
	city,
	round(avg(VAT),2) as VAT
from sales
group by city
order by VAT desc;

-- Which customer type pays the most in VAT?
select 
	customer_type ,
	round(avg(VAT),2) as average_VAT
from sales
group by customer_type
order by average_VAT;







 


