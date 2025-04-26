-- Creating the table

drop table if exists Choco_sales;

create table if not exists Choco_sales
	(
		sales_id serial primary key,
		sales_person varchar(25),
		country varchar(15),
		product varchar(25),
		date date,
		amount numeric(8,2),
		boxes_shipped integer
	);

-- Import data from csv file via pgAdmin GUI's import feature

--checing all data
select * 
from Choco_sales;

--top 5 salespeople by total revenue
select 
	sales_person,
	sum(amount) as total_revenue
from Choco_sales
	group by sales_person
	order by total_revenue desc
	limit 5;

--country generating the highest sales volume
select
	country,
	sum(amount) as revenue
from Choco_sales
	group by country
	order by revenue desc;

--most revenue making 
select
	product,
	sum(amount) as product_revenue
from Choco_sales
	group by product
	order by product_revenue desc;

--products more popular in specific countries
select distinct on (country)
	country,
	product,
	count (*) sales_count
from Choco_sales
	group by country, product
	order by 1, 3 desc;

--monthly sales trend
with max_date as 
	(
		select max(date) latest_date
		from Choco_sales
	)
select 
	extract(month from date) as month_no,
	to_char(date, 'Month') as months,
	sum(amount) as monthly_revenue
from Choco_sales, max_date
where date >= latest_date - interval '1 year'
	group by 1,2
	order by 1;

-- seasonal trends
select distinct on (extract(month from date))
	extract(month from date) as month_no,
	to_char(date, 'Month') as months,
	product,
	count(*) as sales_count
from Choco_sales
group by 1,2,3
order by 1;

-- most consistent sales performers
with monthly_sales as 
	(
	    select 
	        sales_person,
	        extract (month from date) as month_no,
	        SUM(amount) AS monthly_amount
	    from Choco_sales
	    group by sales_person, month_no
	)
select 
	sales_person,
	stddev(monthly_amount) as sales_consistency
from monthly_sales
	group by sales_person
	order by sales_person;
	
--

