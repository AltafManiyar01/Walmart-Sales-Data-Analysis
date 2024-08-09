use marveldb;
select * from walmartsalesdata;





















-- --------------------------------------------------------------------------------------------
-- -----------------------------------Feature Engineering -------------------------------------
-- Time --
select time, case
when Time between "00:00:00" and "12:00:00" then "Morning"
when Time between "12:01:00" and "16:00:00" then "Afternoon"
else "Evening"
end as "Time_of_date"
 from walmartsalesdata;
 alter table walmartsalesdata add column Time_of_date varchar(20);
 select * from walmartsalesdata;
 -- Check the current status of safe update mode
SELECT @@SQL_SAFE_UPDATES;

-- Disable safe update mode
SET SQL_SAFE_UPDATES = 0;

-- Check again to ensure it's disabled
SELECT @@SQL_SAFE_UPDATES;

 
 UPDATE walmartsalesdata
SET Time_of_date = 
    CASE
        WHEN Time >= '00:00:00' AND Time < '12:00:00' THEN 'Morning'
        WHEN Time >= '12:00:00' AND Time < '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END;
    select * from walmartsalesdata;
    
    -- Day_Name----
    select date, dayname(date) from  walmartsalesdata;
    alter table walmartsalesdata add column Day_name varchar(15);
    update walmartsalesdata
    set Day_name = (dayname(date));
    select * from walmartsalesdata;
    
    
    --- Month Name
    
select date, monthname(date) from walmartsalesdata;
alter table walmartsalesdata add column month_name varchar(10);
update walmartsalesdata
set month_name = monthname(date);
select * from walmartsalesdata;

---------- Business Question to Answer ------------
---------- Generic Question ---------
-- 1. How many unique city does the data have? -------

select distinct city from walmartsalesdata;

-- 2. How many unique branches does have the data? ---- or which city and which branches

select distinct city, branch from walmartsalesdata;

-------------------------------------------------------------------------------------------

--- How many unique product lines does have the data----
select *from walmartsalesdata;

SELECT COUNT(DISTINCT "Product line") FROM walmartsalesdata;

---- What is the most common payment method ?
select Payment,count(payment) as cnt from walmartsalesdata 
group by Payment order by cnt desc;

--- What is the most selling product line?
select "Product line", count("Product line") as cnt
from walmartsalesdata group by "product line" order by cnt desc;

SELECT Product_line, COUNT(Product_line) AS cnt
FROM walmartsalesdata
GROUP BY Product_line
ORDER BY cnt DESC;
select Product line from walmartsalesdata;





---- Change column name -----
ALTER TABLE walmartsalesdata
CHANGE COLUMN `Product line` product_line VARCHAR(30);
ALTER TABLE walmartsalesdata CHANGE column `Tax 5%` VAT int;


select * from walmartsalesdata;


--- What is the total revenue by month ?
select month_name, sum(total) as total_revenue 
from walmartsalesdata group by month_name
order by total_revenue desc;

-- What month had the largest COGS?
select month_name as month,
sum(cogs) as cogs from walmartsalesdata
group by month order by cogs desc;

-- What product line had the largest revenue?
select product_line,
sum(total) as total_Revenue
from walmartsalesdata group by product_line
order by total_revenue desc;

-- What is the city with largest revenue?
select city, branch, sum(total) as total_revenue
from walmartsalesdata group by city, branch
order by  total_revenue desc;

-- What product line had largest VAT?
select product_line, avg(vat) as avg_tax
from walmartsalesdata group by product_line
order by avg_tax desc;

-- Which branch sold more products than average product sold?

select branch,
sum(quantity) as qty
from walmartsalesdata group by Branch
having sum(Quantity) > (select avg(Quantity) from walmartsalesdata);

-- What is the most common product line by gender?
select gender,product_line,
count(gender) as ctk from walmartsalesdata
group by gender,product_line order by ctk desc; 

-- What is the average rating of each product line?
select * from walmartsalesdata;
select product_line, round(avg(rating),2) as Avg_rating from walmartsalesdata
group by product_line order	by Avg_rating desc;

------------------------------ Sales -------------------------------------------------
-- Number of Sales made in each time of the day per week?
select * from walmartsalesdata;
select time_of_date, count(*) as total_Sales from
walmartsalesdata group by Time_of_date
order by total_sales desc;
------ As per specific date ----------
select time_of_date, count(*) as total_Sales from
walmartsalesdata where 
Day_name = "Sunday"
 group by Time_of_date
order by total_sales desc;

-- Which of the customer type brings the most revenue?
select `customer type`, sum(total) as member_revenue
from walmartsalesdata group by `Customer type`
order by member_revenue desc;

-- Which City has the largest tax perent/ VAT ( Value added Tax)?
select * from walmartsalesdata;
select city, max(VAT) as Max_VAT from
walmartsalesdata group by city	
order by Max_VAT;

-- Which customer type pays the most in VAT?
select * from  walmartsalesdata;
select `customer type`, round(avg(VAT), 2) as Avg_VAT
from walmartsalesdata group by `customer type`
order by Avg_VAT desc;

----------------------- Customer ---------------------------------------
-- How many unique customer type does the data have?
SELECT `customer type`, COUNT(`customer type`) as Uni_Cx
from walmartsalesdata GROUP BY `customer type` ORDER BY
`customer type` desc;

SELECT COUNT(DISTINCT `customer type`) AS Uni_Cx
FROM walmartsalesdata;

-- HOW MANY UNIQUE PAYMENT METHODS DOES THE DATA HAVE?
SELECT * FROM walmartsalesdata;
SELECT COUNT(DISTINCT `Payment`) AS Uni_Pay
FROM walmartsalesdata;

--- WHAT IS THE MOST COMMON CUSTOMER TYPE?
SELECT * FROM walmartsalesdata;
select `customer type`, count(*) as common_member
from walmartsalesdata group by `customer type`
order by common_member desc;

-- which customer type buy the most?

select `customer type`, count(*) as common_member
from walmartsalesdata group by `customer type`
order by common_member desc;
-- What is the gender of most of the customer?
SELECT gender, COUNT(*) AS CNT
FROM walmartsalesdata
GROUP BY gender ORDER BY CNT DESC;

-- WHAT IS THE GENDER DISTRIBUTION PER BRANCH?
SELECT gender, branch, COUNT(*) AS GEN_CNT
FROM walmartsalesdata
GROUP BY gender, branch
ORDER BY branch;

-- WHAT TIME OF THE DAY DO CUSTOMER GIVE MOST RATING..?
SELECT * FROM walmartsalesdata;

SELECT TIME_OF_DATE, AVG(RATING) AS AVG_RATE
FROM walmartsalesdata GROUP BY TIME_OF_DATE
ORDER BY AVG_RATE DESC;

-- WHICH TIME OF THE DAY DO CUSTOMERS GIVE MOST RATING PER BRANCH..?
SELECT TIME_OF_DATE, BRANCH, AVG(RATING) AS RATE_BRANCH
FROM walmartsalesdata GROUP BY TIME_OF_DATE, BRANCH
ORDER BY RATE_BRANCH DESC;

-- WHCIH DAY OF THE WEEK HAS THE BEST AVG RATING..?
SELECT * FROM walmartsalesdata;
SELECT DAY_NAME, AVG(RATING) AS RATE_DAY
FROM walmartsalesdata GROUP BY DAY_NAME
ORDER BY RATE_DAY DESC;

SELECT * FROM walmartsalesdata;
SELECT DAY_NAME,BRANCH,  AVG(RATING) AS RATE_DAY
FROM walmartsalesdata GROUP BY DAY_NAME, BRANCH
ORDER BY RATE_DAY DESC;


---------------------------------------------------------------------------------
---------------------------------------------------------------------------------












































































































































    