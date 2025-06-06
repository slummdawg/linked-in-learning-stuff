-- SQL retail sales analysis
CREATE DATABASE sql_proejct_p4;

DROP TABLE IF EXISTS retail_sales_tb;

CREATE TABLE retail_sales_tb(
	transactions_id	 INT,
	sale_date DATE,
	sale_time TIME,
	customer_id	INT,
    gender VARCHAR(15),
	age	INT,
    category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale float,
    PRIMARY KEY (transactions_id)
    );
    
SELECT * FROM retail_sales_tb;

SELECT count(*) FROM retail_sales_tb;

-- data cleaning
SELECT * FROM retail_sales_tb
where quantiy is null;

-- data exploration

-- how many sales we have?
select count(*) as total_sales from retail_sales_tb;

-- how many unique customer we have?
select count(distinct customer_id) as total_customer from retail_sales_tb;

-- how many unique category we have?
select count(distinct category) as category from retail_sales_tb;

-- data analysis & business key probelms and answers

-- Q1
select * from retail_sales_tb
where sale_date = '2022-11-05';
-- Q2
select * from retail_sales_tb
where
	category = 'Clothing' and quantiy >= 4 and sale_date between '2022-11-01' and '2022-11-30';
-- Q3
select
	category,
	sum(total_sale) as category_sales,
	COUNT(*) as total_orders
from retail_sales_tb
group by
	category;
-- Q4
select
	round(avg(age)) as avg_age
from retail_sales_tb
where
	category = 'Beauty';
-- Q5
select * from retail_sales_tb
where total_sale > 1000;
-- Q6
select
	count(*) as total_transaction,
    gender,
    category
from retail_sales_tb
group by
	gender, category
order by
	category;
-- Q7
select * from
(
select
    year(sale_date) as year,
    month(sale_date) as month,
    avg(total_sale) as avg_sale,
    rank() over(partition by year(sale_date) order by avg(total_sale) desc) as ranked
from retail_sales_tb
group by 1, 2
) as t1
where ranked = 1;
-- Q8
select 
	customer_id,
    SUM(total_sale) as total_sale
 from retail_sales_tb
 group by 1
 order by 2 desc
 limit 5
-- Q9
select
	category,
	count(distinct(customer_id)) as unique_cust
from retail_sales_tb
group by category
-- Q10
with cte as (
select *,
	case
		when hour(sale_time) < 12 then 'Morning'
        when hour(sale_time) between 12 and 17 then 'Afternoon'
        else 'Evening'
	end as shift
from retail_sales_tb
 )
select shift, count(*) as total_orders from cte
group by shift
