# Chocolate-Sales-SQL-Project
This project is done by Saran R for showcasing skills in SQL using PostgreSQl and pgAdmin4 interface for data analysis.

## Dataset
Dataset for this project was obtained from Kaggle - [Chocolate_Sales.csv](https://www.kaggle.com/datasets/atharvasoundankar/chocolate-sales).

## Objective
To clean and derive business insights from the raw dataset with simple Querries.

## Steps Taken
### Cleaning Data
Data was cleaned by using Excel.
- Data types corrcted
- Date format corrected
- Sales id was added as primary key.
#### Before
![Screenshot 2025-04-22 072056](https://github.com/user-attachments/assets/f71c7657-9b7c-488b-833a-a60a8478ea55)
#### After
![Screenshot 2025-04-22 074118](https://github.com/user-attachments/assets/23b6d170-828b-41f5-a39f-0b4edc44b05c)

### Establishing the Table
A data base was allocated in the PostgeSQl seperately for this project namely "chocolate_project" directly from the pgAdmin UI.

![Screenshot 2025-04-22 071514](https://github.com/user-attachments/assets/6f627971-8b05-4ed7-a444-299d813808cf)


#### The Schema of the Table
```sql
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
```

### Importing Data 
Data was imported from the UI option of pgAdmin4.
![Screenshot 2025-04-22 072644](https://github.com/user-attachments/assets/fc16cc3e-b007-4b75-ad20-786efdcbb275)

### Querries
1. Top 5 salespeople by total revenue
```sql
select 
	sales_person,
	sum(amount) as total_revenue
from Choco_sales
	group by sales_person
	order by total_revenue desc
	limit 5;
```
2. Country generating the highest sales volume
```sql
select
	country,
	sum(amount) as revenue
from Choco_sales
	group by country
	order by revenue desc;

```
3. Most revenue making Product
```sql
select
	product,
	sum(amount) as product_revenue
from Choco_sales
	group by product
	order by product_revenue desc;
```
4. Products more popular in specific countries
```sql
select distinct on (country)
	country,
	product,
	count (*) sales_count
from Choco_sales
	group by country, product
	order by 1, 3 desc;
```
5. Monthly sales trend
```sql
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
	order by 1
```
6. Seasonal trends
```sql
select distinct on (extract(month from date))
	extract(month from date) as month_no,
	to_char(date, 'Month') as months,
	product,
	count(*) as sales_count
from Choco_sales
group by 1,2,3
order by 1;
```
7. Most consistent sales performers
```sql
with monthly_sales as 
	(
	    select 
	        sales_person,
	        extract (month from date) as month_no,
	        SUM(amount) as monthly_amount
	    from Choco_sales
	    group by sales_person, month_no
	)
select 
	sales_person,
	stddev(monthly_amount) as sales_consistency
from monthly_sales
	group by sales_person
	order by sales_person;
```
