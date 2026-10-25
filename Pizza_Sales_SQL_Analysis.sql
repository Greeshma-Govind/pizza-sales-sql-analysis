-- =========================================================
-- PIZZA SALES SQL ANALYSIS PROJECT
-- Author  : Greeshma K.G.
-- Database: pizza_sales_db
-- Tool    : MySQL + DBeaver
-- =========================================================

-- ==========================================
-- SECTION 1 : DATA EXPLORATION
-- ==========================================

/*==========================================================
Query 1: Check Active Database

Business Question:
Which database am I currently connected to?

Purpose:
Verify that the correct database is selected before
executing SQL queries.
==========================================================*/

SELECT DATABASE();

/*==========================================================
Query 2: Display All Data

Business Question:
What does the complete dataset look like?

Purpose:
Display all records and columns to understand the
structure of the dataset before analysis.
==========================================================*/

SELECT
	*
FROM
	pizza_sales_db.pizza_sales;

/*==========================================================
Query 3: Count Total Records

Business Question:
How many sales records are available in the dataset?

Purpose:
Verify whether the data has been imported completely
and determine the total number of rows.
==========================================================*/

SELECT
	COUNT(*) AS total_records
FROM 
	pizza_sales;

/*==========================================================
Query 4: Count Total Orders

Business Question:
How many unique customer orders were placed?

Purpose:
Count distinct order IDs because one order may contain
multiple pizza items.
==========================================================*/

SELECT
	COUNT(DISTINCT order_id) AS total_records
FROM
	pizza_sales;

/*==========================================================
Query 5: Count Pizza Varieties

Business Question:
How many different pizza types are available?

Purpose:
Determine the number of unique pizzas sold by the
restaurant.
==========================================================*/

SELECT
	COUNT(DISTINCT pizza_name_id) AS total_pizza_types
FROM
	pizza_sales;

/*==========================================================
Query 6: Find Data Range

Business Question:
What is the time period covered by this dataset?

Purpose:
Find the earliest and latest order dates available
for analysis.
==========================================================*/

SELECT
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date
FROM
	pizza_sales;

-- ==========================================
-- SECTION 2 : SALES ANALYSIS
-- ==========================================

/*==========================================================
Query 7: Calculate Total Revenue

Business Question:
What is the total revenue generated from pizza sales?

Purpose:
Calculate the overall revenue earned from all
pizza orders.
==========================================================*/

SELECT
	SUM(total_price) AS total_revenue
FROM
	pizza_sales;

/*==========================================================
Query 8: Calculate Average Order Value

Business Question:
What is the average revenue generated per sales record?

Purpose:
Calculate the average value by dividing total revenue
by the total number of records.

Note:
This is the average revenue per row, not the average
revenue per customer order.
==========================================================*/

SELECT
	SUM(total_price)/ COUNT(order_id) AS avg_ordr_value
FROM
	pizza_sales;

/*==========================================================
Query 9: Most Ordered Pizza Size

Business Question:
Which pizza size is ordered the most?

Purpose:
Calculate the total quantity sold for each pizza size
and rank them from highest to lowest.

Note:
group by - groups rows that have the same value in one or more columns, allowing aggregate functions like 
SUM(), COUNT(), and AVG() to calculate results for each group instead of the entire table
==========================================================*/

SELECT
	pizza_size,
	SUM(quantity) AS total_quantity
FROM
	pizza_sales
GROUP BY
	pizza_size -- will group according to what put after group by --
ORDER BY
	total_quantity DESC ; -- will show highest in the top --

/*==========================================================
Query 10: Revenue by Pizza Category

Business Question:
Which pizza category generates the highest revenue?

Purpose:
Calculate total revenue for each pizza category and
rank them from highest to lowest.
==========================================================*/	
	
SELECT
	pizza_category,
	SUM(total_price) AS total_revenue
FROM
	pizza_sales
GROUP BY
	pizza_category
ORDER BY
	total_revenue DESC ;

/*==========================================================
Query 11: Average Revenue by Pizza Category

Business Question:
Which pizza category has the highest average sales value?

Purpose:
Calculate the average revenue generated per sales
record for each pizza category.
==========================================================*/

SELECT
	pizza_category,
	AVG(total_price) AS avg_revenue
FROM
	pizza_sales
GROUP BY
	pizza_category
ORDER BY
	avg_revenue DESC ;

/*==========================================================
Query 12: Revenue by Day of the Week

Business Question:
Which day of the week generates the highest revenue?

Purpose:
Calculate total revenue for each day and rank them
from highest to lowest.
==========================================================*/

SELECT
	order_day,
	SUM(total_price) as total_revenue
FROM
	pizza_sales
GROUP BY
	order_day
ORDER BY
	total_revenue DESC ;

/*==========================================================
Query 13: Top 5 Pizzas by Revenue

Business Question:
Which five pizzas generate the highest revenue?

Purpose:
Calculate total revenue for each pizza and display
the top five highest-performing pizzas.
==========================================================*/

SELECT
	pizza_name_id,
	SUM(total_price) AS total_revenue
FROM
	pizza_sales
GROUP BY
	pizza_name_id
ORDER BY
	total_revenue DESC
LIMIT 5 ;

/*==========================================================
Query 14: Bottom 5 Pizzas by Revenue

Business Question:
Which five pizzas generate the lowest revenue?

Purpose:
Identify the lowest-performing pizzas based on total revenue.

SQL Concepts Used:
- SUM()
- GROUP BY
- ORDER BY
- LIMIT
==========================================================*/

SELECT
	pizza_name_id,
	SUM(total_price) AS total_revenue
FROM
	pizza_sales
GROUP BY
	pizza_name_id
ORDER BY
	total_revenue ASC
LIMIT 5 ;

/*==========================================================
Query 15: Revenue by Pizza Size

Business Question:
Which pizza size generates the highest revenue?

Purpose:
Calculate the total revenue generated by each pizza size
and rank them from highest to lowest.

SQL Concepts Used:
- SUM()
- GROUP BY
- ORDER BY
==========================================================*/

SELECT
	pizza_size,
	SUM(total_price) AS total_revenue
FROM
	pizza_sales
GROUP BY
	pizza_size
ORDER BY
	total_revenue DESC ;

/*==========================================================
Query 16: Peak Business Hour

Business Question:
During which hour of the day are the most pizzas ordered?

Purpose:
Identify the busiest hour based on the total quantity of
pizzas sold to help with staff scheduling and inventory planning.

SQL Concepts Used:
- HOUR()
- COUNT(DISTINCT)
- GROUP BY
- ORDER BY
==========================================================*/

SELECT
	HOUR(order_time) AS order_hour,
	COUNT(DISTINCT order_id) AS total_orders
FROM
	pizza_sales
GROUP BY
	order_hour 
ORDER BY
	total_orders DESC ;

/*==========================================================
Query 17: Percentage Contribution by Pizza Category

Business Question:
What percentage of the total revenue does each pizza
category contribute?

Purpose:
Calculate the percentage contribution of each pizza
category to the overall revenue. This helps identify
which categories contribute the most to total sales.

SQL Concepts Used:
- SUM()
- ROUND()
- Subquery
- GROUP BY
- ORDER BY
==========================================================*/

SELECT
	pizza_category,
	ROUND(SUM(total_price)/ (SELECT SUM(total_price) FROM pizza_sales)* 100, 2) AS percentage_contribution
FROM
	pizza_sales
GROUP BY
	pizza_category
ORDER BY
	percentage_contribution DESC ;

/*==========================================================
Query 19: Percentage Contribution by Pizza Size

Business Question:
What percentage of the total revenue does each pizza
size contribute?

Purpose:
Calculate the percentage contribution of each pizza
size to the overall revenue. This helps identify
which pizza size contributes the most to total sales.

SQL Concepts Used:
- SUM()
- ROUND()
- Subquery
- GROUP BY
- ORDER BY
==========================================================*/

SELECT
	pizza_size,
	ROUND(SUM(total_price)/ (SELECT SUM(total_price) FROM pizza_sales)* 100, 2) AS percentage_contribution
FROM
	pizza_sales
GROUP BY
	pizza_size
ORDER BY
	percentage_contribution DESC ;

-- ==========================================
-- SECTION 3 : PRODUCT ANALYSIS
-- ==========================================

/*==========================================================
Query 20: Highest Revenue-Generating Pizza

Business Question:
Which pizza generated the highest total revenue?

Purpose:
Identify the pizza that contributes the most revenue to
the business. This helps understand the strongest
revenue-generating product.

SQL Concepts Used:
- SUM()
- GROUP BY
- ORDER BY
- LIMIT
==========================================================*/

SELECT
	pizza_name_id,
	SUM(total_price) AS total_revenue
FROM
	pizza_sales
GROUP BY
	pizza_name_id
ORDER BY
	total_revenue DESC
LIMIT 1 ;

/*==========================================================
Query 21: Highest-Selling Pizza by Quantity

Business Question:
Which pizza sold the highest total quantity?

Purpose:
Identify the pizza with the highest total number of units
sold to understand the strongest-selling product by volume.

SQL Concepts Used:
- SUM()
- GROUP BY
- ORDER BY
- LIMIT
==========================================================*/

SELECT
	pizza_name_id,
	SUM(quantity) AS total_quantity
FROM
	pizza_sales
GROUP BY
	pizza_name_id
ORDER BY
	total_quantity DESC
LIMIT 1 ; 

/*==========================================================
COUNT(), COUNT(DISTINCT) & SUM()

COUNT():
Counts the number of rows/records.

COUNT(DISTINCT):
Counts only unique values, ignoring duplicates.

SUM():
Adds together numeric values in a column.

COUNT = rows
COUNT(DISTINCT) = unique values
SUM = total amount
==========================================================*/

/*==========================================================
Query 22: Lowest-Selling Pizza by Quantity

Business Question:
Which pizza sold the lowest total quantity?

Purpose:
Identify the pizza with the lowest total number of units
sold to understand the weakest-selling product by volume.

SQL Concepts Used:
- SUM()
- GROUP BY
- ORDER BY
- LIMIT
==========================================================*/

SELECT
	pizza_name_id,
	SUM(quantity) AS total_quantity
FROM
	pizza_sales
GROUP BY
	pizza_name_id
ORDER BY
	total_quantity ASC
LIMIT 1 ;

/*==========================================================
Query 23: Top 5 Pizzas by Quantity Sold

Business Question:
Which five pizzas sold the highest total quantity?

Purpose:
Identify the top five best-selling pizzas based on the
total number of units sold.

SQL Concepts Used:
- SUM()
- GROUP BY
- ORDER BY
- LIMIT
==========================================================*/

SELECT
	pizza_name_id,
	SUM(quantity) AS total_quantity
FROM
	pizza_sales
GROUP BY
	pizza_name_id
ORDER BY
	total_quantity DESC
LIMIT 5 ; 

/*==========================================================
Query 24: Bottom 5 Pizzas by Quantity Sold

Business Question:
Which five pizzas sold the lowest total quantity?

Purpose:
Identify the five least-selling pizzas based on total
units sold. This can help identify products that may need
promotion, pricing review, or menu evaluation.

SQL Concepts Used:
- SUM()
- GROUP BY
- ORDER BY
- LIMIT
==========================================================*/

SELECT
	pizza_name_id,
	SUM(quantity) AS total_quantity
FROM
	pizza_sales
GROUP BY
	pizza_name_id
ORDER BY
	total_quantity ASC
LIMIT 5 ;

/*==========================================================
Query 25: Highest Average Revenue per Pizza

Business Question:
Which pizza has the highest average revenue per order line?

Purpose:
Identify the pizza with the highest average revenue
generated per record/order line.

SQL Concepts Used:
- AVG()
- GROUP BY
- ORDER BY
- LIMIT
==========================================================*/

SELECT
	pizza_name_id,
	AVG(total_price) AS avg_revenue
FROM
	pizza_sales
GROUP BY
	pizza_name_id
ORDER BY
	avg_revenue DESC
LIMIT 1 ;

/*==========================================================
Query 26: Lowest Average Revenue per Pizza

Business Question:
Which pizza has the lowest average revenue per order line?

Purpose:
Identify the pizza with the lowest average revenue
generated per record/order line.

SQL Concepts Used:
- AVG()
- GROUP BY
- ORDER BY
- LIMIT
==========================================================*/

SELECT
    pizza_name_id,
    AVG(total_price) AS avg_revenue
FROM
    pizza_sales
GROUP BY
    pizza_name_id
ORDER BY
    avg_revenue ASC
LIMIT 1 ;

/*==========================================================
Query 27: Total Quantity Sold by Pizza Category

Business Question:
How many pizzas were sold in total for each pizza category?

Purpose:
Identify which pizza category has the highest total number
of units sold.

SQL Concepts Used:
- SUM()
- GROUP BY
- ORDER BY
==========================================================*/

SELECT
	pizza_category,
	SUM(quantity) AS total_quantity
FROM
	pizza_sales
GROUP BY
	pizza_category
ORDER BY
	total_quantity DESC ;

/*==========================================================
Query 28: Percentage Contribution by Pizza Category Based
on Quantity Sold

Business Question:
What percentage of the total quantity sold comes from
each pizza category?

Purpose:
Determine how much each pizza category contributes to the
overall number of pizza units sold.

SQL Concepts Used:
- SUM()
- ROUND()
- Subquery
- GROUP BY
- ORDER BY
==========================================================*/

SELECT
	pizza_category,
	ROUND(SUM(quantity)/(SELECT SUM(quantity) FROM pizza_sales )* 100, 2) AS percentage_contribution
FROM
	pizza_sales
GROUP BY
	pizza_category
ORDER BY
	percentage_contribution DESC ;

/*==========================================================
Query 29: Highest Average Quantity per Pizza Category

Business Question:
Which pizza category has the highest average quantity
per order line?

Purpose:
Identify the pizza category with the highest average
number of pizza units sold per order line.

SQL Concepts Used:
- AVG()
- GROUP BY
- ORDER BY
- LIMIT
==========================================================*/

SELECT
	pizza_category,
	AVG(quantity) AS avg_quantity
FROM
	pizza_sales
GROUP BY
	pizza_category
ORDER BY
	avg_quantity DESC
LIMIT 1 ;

/*==========================================================
Query 30: Lowest Average Quantity per Pizza Category

Business Question:
Which pizza category has the lowest average quantity
per order line?

Purpose:
Identify the pizza category with the lowest average
number of pizza units sold per order line.

SQL Concepts Used:
- AVG()
- GROUP BY
- ORDER BY
- LIMIT
==========================================================*/

SELECT
	pizza_category,
	AVG(quantity) AS avg_quantity
FROM
	pizza_sales
GROUP BY
	pizza_category
ORDER BY
	avg_quantity ASC 
LIMIT 1 ;

-- ==========================================
-- SECTION 4 : TIME BASED ANALYSIS
-- ==========================================

/*==========================================================
Query 31: Total Orders by Hour

Business Question:
How many orders were placed during each hour of the day?

Purpose:
Analyze order patterns throughout the day and identify
which hours receive more or fewer orders.

SQL Concepts Used:
- HOUR()
- COUNT(DISTINCT)
- GROUP BY
- ORDER BY
==========================================================*/

SELECT
	HOUR(order_time),
	COUNT(DISTINCT order_id ) AS order_per_hour
FROM
	pizza_sales
GROUP BY
	HOUR(order_time)
ORDER BY
	order_per_hour DESC ;

/*==========================================================
Query 32: Total Revenue by Hour

Business Question:
What is the total revenue generated during each hour
of the day?

Purpose:
Analyze hourly revenue patterns and identify which hours
generate the highest revenue.

SQL Concepts Used:
- HOUR()
- SUM()
- GROUP BY
- ORDER BY
==========================================================*/

SELECT
	HOUR(order_time),
	SUM(total_price) AS total_revenue_per_hr
FROM
	pizza_sales
GROUP BY
	HOUR(order_time)
ORDER BY
	total_revenue_per_hr DESC ;

/*==========================================================
Query 33: Average Revenue per Hour

Business Question:
What is the average revenue generated per order line
during each hour of the day?

Purpose:
Analyze the average revenue generated during each hour
and identify the hours with higher average transaction
values.

SQL Concepts Used:
- HOUR()
- AVG()
- ROUND()
- GROUP BY
- ORDER BY
==========================================================*/

SELECT
	HOUR(order_time),
	ROUND(AVG(total_price),2) AS avg_revenue_per_hr
FROM
	pizza_sales
GROUP BY
	HOUR(order_time)
ORDER BY
	avg_revenue_per_hr DESC ;

/*==========================================================
Query 34: Peak Hour by Pizza Quantity Sold

Business Question:
Which hour of the day has the highest number of pizzas sold?

Purpose:
Identify the peak hour based on the total number of pizza
units sold.

SQL Concepts Used:
- HOUR()
- SUM()
- GROUP BY
- ORDER BY
- LIMIT
==========================================================*/

SELECT
	HOUR(order_time),
	SUM(quantity) AS total_pizza_sold
FROM
	pizza_sales
GROUP BY
	HOUR(order_time)
ORDER BY
	total_pizza_sold DESC
LIMIT 1;

/*==========================================================
Query 35: Lowest Hour by Pizza Quantity Sold

Business Question:
Which hour of the day has the lowest number of pizzas sold?

Purpose:
Identify the hour with the lowest total number of pizza
units sold.

SQL Concepts Used:
- HOUR()
- SUM()
- GROUP BY
- ORDER BY
- LIMIT
==========================================================*/

SELECT
	HOUR(order_time),
	SUM(quantity) AS total_pizza_sold
FROM
	pizza_sales
GROUP BY
	HOUR(order_time)
ORDER BY
	total_pizza_sold ASC 
LIMIT 1;

/*==========================================================
Query 36: Highest Average Order Value by Hour

Business Question:
Which hour of the day has the highest average order value?

Purpose:
Identify the hour during which customers generate the
highest average revenue per order.

SQL Concepts Used:
- HOUR()
- SUM()
- COUNT(DISTINCT)
- ROUND()
- GROUP BY
- ORDER BY
- LIMIT
==========================================================*/

SELECT
	HOUR(order_time),
	ROUND(SUM(total_price) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM
	pizza_sales
GROUP BY
	HOUR(order_time)
ORDER BY
	avg_order_value DESC
LIMIT 1 ;

/*==========================================================
Query 37: Revenue by Pizza Size and Hour

Business Question:
What is the total revenue generated by each pizza size
during each hour of the day?

Purpose:
Analyze the relationship between pizza size, time of day,
and revenue to identify which size-hour combinations
generate the most revenue.

SQL Concepts Used:
- HOUR()
- SUM()
- GROUP BY with multiple columns
- ORDER BY
==========================================================*/

SELECT
	HOUR(order_time) AS order_hour,
	pizza_size,
	SUM(total_price) AS total_revenue
FROM
	pizza_sales
GROUP BY
	order_hour ,
	pizza_size
ORDER BY
	total_revenue DESC ;

/*==========================================================
Query 38: Quantity Sold by Pizza Size and Hour

Business Question:
How many pizza units of each size were sold during each
hour of the day?

Purpose:
Analyze pizza size demand across different hours and
identify the size-hour combinations with the highest
quantity of pizzas sold.

SQL Concepts Used:
- HOUR()
- SUM()
- GROUP BY with multiple columns
- ORDER BY
==========================================================*/

SELECT
	HOUR(order_time) AS order_hour,
	pizza_size,
	SUM(quantity) AS total_quantity
FROM
	pizza_sales
GROUP BY
	order_hour ,
	pizza_size
ORDER BY
	total_quantity DESC ;

/*==========================================================
Query 39: Revenue by Pizza Category and Hour

Business Question:
What is the total revenue generated by each pizza category
during each hour of the day?

Purpose:
Analyze the relationship between pizza category, time of
day, and revenue to identify which category and hour
combinations generate the highest revenue.

SQL Concepts Used:

- HOUR()
- SUM()
- GROUP BY
- GROUP BY with multiple columns
- ORDER BY
- Column Aliases
==========================================================*/

SELECT
	HOUR(order_time) AS order_hour,
	pizza_category,
	SUM(total_price) AS total_revenue
FROM
	pizza_sales
GROUP BY
	order_hour ,
	pizza_category
ORDER BY
	total_revenue DESC ;

/*==========================================================
Query 40: Percentage Contribution by Pizza Category and Size

Business Question:
What percentage of the total revenue is contributed by
each pizza category and pizza size combination?

Purpose:
Analyze the revenue contribution of each category-size
combination and identify which combinations contribute the
most to the overall business revenue.

SQL Concepts Used:

- SUM()
- ROUND()
- Subquery
- GROUP BY with multiple columns
- ORDER BY
- Percentage calculation
- Column Alias
==========================================================*/

SELECT
	pizza_category,
	pizza_size,
	ROUND(
			SUM(total_price)/
			(SELECT SUM(total_price) FROM pizza_sales)* 100, 
			2
		) AS percentage_contribution
FROM
	pizza_sales
GROUP BY
	pizza_category ,
	pizza_size
ORDER BY
	percentage_contribution DESC ;

-- ==========================================
-- SECTION 5 : Advanced Business Analysis
-- ==========================================

/*==========================================================
Query 41: Orders with Multiple Pizzas

Business Question:
Which orders contain more than one pizza?

Purpose:
Identify orders where customers purchased multiple pizzas
within the same order. This helps understand larger orders
and customer purchasing behavior.

SQL Concepts Used:

- SUM()
- GROUP BY
- HAVING
- ORDER BY
- Column Alias
==========================================================*/

SELECT
	order_id,
	SUM(quantity) AS total_quantity
FROM
	pizza_sales
GROUP BY
	order_id
HAVING
	total_quantity >1
ORDER BY
	total_quantity ;

/*==========================================================
  
  NOTE:-
  
| Clause     | Purpose                                     |
| ---------- | ------------------------------------------- |
| `WHERE`    | Filters individual rows **before grouping** |
| `GROUP BY` | Creates groups                              |
| `HAVING`   | Filters groups **after grouping**           |
| `ORDER BY` | Sorts the final results                     |

==========================================================*/

/*==========================================================
Query 42: Pizza Types with High Sales Volume

Business Question:
Which pizza types have sold more than 1,000 units in total?

Purpose:
Identify pizza types with high sales volume by calculating
the total quantity sold for each pizza and filtering for
pizzas that sold more than 1,000 units.

SQL Concepts Used:

- SUM()
- GROUP BY
- HAVING
- ORDER BY
- Column Alias
==========================================================*/

SELECT
	pizza_name_id ,
	SUM(quantity) AS total_quantity
FROM
	pizza_sales
GROUP BY
	pizza_name_id
HAVING
	total_quantity > 1000
ORDER BY
	total_quantity DESC ;

/*==========================================================
WHERE vs HAVING

WHERE:
- Filters individual rows BEFORE GROUP BY.
- Used to filter the original data.
- Cannot normally be used with aggregate results such as
  SUM(), AVG(), COUNT() in the filtering condition.

Example:
SELECT
    pizza_category,
    SUM(quantity) AS total_quantity
FROM
    pizza_sales
WHERE
    pizza_size = 'L'
GROUP BY
    pizza_category;

Meaning:
First keep only Large pizzas, then group the remaining
rows by pizza category.
----------------------------------------------------------

HAVING:
- Filters groups AFTER GROUP BY.
- Used to filter aggregated/grouped results.
- Commonly used with SUM(), AVG(), COUNT(), etc.

Example:
SELECT
    pizza_name_id,
    SUM(quantity) AS total_quantity
FROM
    pizza_sales
GROUP BY
    pizza_name_id
HAVING
    total_quantity > 1000;

Meaning:
First group the data by pizza, calculate total quantity
for each pizza, then keep only pizzas whose total quantity
is greater than 1,000.
----------------------------------------------------------

KEY DIFFERENCE:

WHERE  → filters ROWS before grouping
HAVING → filters GROUPS after grouping

SQL Execution Order:

FROM
  ↓
WHERE
  ↓
GROUP BY
  ↓
HAVING
  ↓
SELECT
  ↓
ORDER BY

|Easy way to remember   |
|---------------------  |
|WHERE = Which rows?    |
|HAVING = Which groups? |

Use WHERE to filter raw rows; use HAVING to filter aggregate/grouped results.

==========================================================*/

/*==========================================================
Query 43: Pizza Types with High Average Selling Price

Business Question:
Which pizza types have an average selling price greater
than 20?

Purpose:
Identify pizza types with a higher average selling price
and rank them from the highest average selling price to
the lowest.

SQL Concepts Used:

- AVG()
- ROUND()
- GROUP BY
- HAVING
- ORDER BY
- Column Alias
==========================================================*/

SELECT
	pizza_name_id,
	ROUND(AVG(total_price), 2) AS avg_selling_price
FROM
	pizza_sales
GROUP BY
	pizza_name_id
HAVING
	avg_selling_price >20
ORDER BY
	avg_selling_price DESC ;

/*==========================================================
Query 44: Pizza Categories with High Total Revenue

Business Question:
Which pizza categories generate more than 200,000 in total
revenue?

Purpose:
Identify pizza categories that generate high total revenue
and rank the qualifying categories from highest revenue
to lowest.

SQL Concepts Used:

- SUM()
- GROUP BY
- HAVING
- ORDER BY
- Column Alias
==========================================================*/

SELECT
	pizza_category,
	SUM(total_price) AS total_revenue
FROM
	pizza_sales
GROUP BY
	pizza_category
HAVING
	total_revenue > 200000
ORDER BY
	total_revenue DESC ;

/*==========================================================
Query 45: Pizza Sizes with High Sales Volume

Business Question:
Which pizza sizes have sold more than 10,000 pizza units
in total?

Purpose:
Identify pizza sizes with high sales volume by calculating
the total number of pizza units sold for each size and
filtering the results to show only sizes that sold more
than 10,000 units.

SQL Concepts Used:

- SUM()
- GROUP BY
- HAVING
- ORDER BY
- Column Alias
==========================================================*/

SELECT
	pizza_size,
	SUM(quantity) AS total_units
FROM
	pizza_sales
GROUP BY
	pizza_size
HAVING
	total_units > 10000
ORDER BY
	total_units DESC ;

/*==========================================================
Query 46: Pizza Categories with High Average Quantity Sold

Business Question:
Which pizza categories have an average quantity sold
greater than 2 pizzas per sale?

Purpose:
Identify pizza categories where customers purchase a
higher average number of pizza units per sale record.

SQL Concepts Used:

- AVG()
- GROUP BY
- HAVING
- ORDER BY
- Column Alias
==========================================================*/

SELECT
	pizza_category,
	AVG(quantity) AS avg_quantity_sold
FROM
	pizza_sales
GROUP BY
	pizza_category
HAVING
	avg_quantity_sold >2
ORDER BY
	avg_quantity_sold DESC ;

/*==========================================================
Query 47: Pizza Types with High Revenue per Unit

Business Question:
Which pizza types generate more than 10 in revenue per
pizza unit sold?

Purpose:
Identify pizza types that generate higher revenue per pizza
unit sold and rank them from the highest revenue per unit
to the lowest.

SQL Concepts Used:

- SUM()
- ROUND()
- Division
- GROUP BY
- HAVING
- ORDER BY
- Column Alias
==========================================================*/

SELECT
	pizza_name_id,
	ROUND(SUM(total_price)/ SUM(quantity), 2) AS revenue_per_unit
FROM
	pizza_sales
GROUP BY
	pizza_name_id
HAVING
	revenue_per_unit > 10
ORDER BY
	revenue_per_unit DESC ;

/*==========================================================
Query 48: Pizza Categories with High Revenue per Unit

Business Question:
Which pizza categories generate more than 10 in revenue per
pizza unit sold?

Purpose:
Identify pizza categories that generate higher revenue per
pizza unit sold and rank the qualifying categories from the
highest revenue per unit to the lowest.

SQL Concepts Used:

- SUM()
- ROUND()
- Division
- GROUP BY
- HAVING
- ORDER BY
- Column Alias
==========================================================*/

SELECT
	pizza_category,
	ROUND(SUM(total_price)/ SUM(quantity), 2) AS revenue_per_unit
FROM
	pizza_sales
GROUP BY
	pizza_category 
HAVING
	revenue_per_unit > 10
ORDER BY
	revenue_per_unit DESC ;

/*==========================================================
Query 49: Pizza Categories with High Average Order Value

Business Question:
Which pizza categories have an average order value greater
than 30?

Purpose:
Identify pizza categories that generate a higher average
revenue per order and rank the qualifying categories from
the highest average order value to the lowest.

SQL Concepts Used:

- SUM()
- COUNT(DISTINCT)
- ROUND()
- Division
- GROUP BY
- HAVING
- ORDER BY
- Column Alias
==========================================================*/

SELECT
	pizza_category,
	ROUND(SUM(total_price)/ COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM
	pizza_sales
GROUP BY
	pizza_category
HAVING
	avg_order_value > 30
ORDER BY
	avg_order_value DESC ;

/*==========================================================
Query 50: Pizza Sizes with High Average Order Value

Business Question:
Which pizza sizes have an average order value greater
than 30?

Purpose:
Identify pizza sizes associated with higher average revenue
per order and rank the qualifying sizes from the highest
average order value to the lowest.

SQL Concepts Used:

- SUM()
- COUNT(DISTINCT)
- ROUND()
- Division
- GROUP BY
- HAVING
- ORDER BY
- Column Alias
==========================================================*/

SELECT
	pizza_size,
	ROUND(SUM(total_price)/ COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM
	pizza_sales
GROUP BY
	pizza_size
HAVING
	avg_order_value > 30
ORDER BY
	avg_order_value DESC ;

-- =============================================
-- SECTION 6 : Comparative & Advanced Analysis
-- =============================================

/*==========================================================

SUBQUERY
──────────────

A subquery is a query inside another query.

Main query
    ↓
asks the main question

Subquery
    ↓
provides an answer needed by the main query


Basic structure:

SELECT ...
FROM ...
WHERE column > (
    SELECT ...
    FROM ...
);

INNER = What must I know first?
OUTER = What am I ultimately trying to find?

==========================================================*/

-- | Question situation                          | Use                 |
-- | ------------------------------------------- | ------------------- |
-- | Inner returns **one value**                 | `>`, `<`, `=`, `<>` |
-- | Inner returns **many values**               | `IN`                |
-- | Many values, want the opposite              | `NOT IN`            |
-- | "Does at least one matching row exist?"     | `EXISTS`            |
-- | "Does no matching row exist?"               | `NOT EXISTS`        |
-- | Need to average **group totals**            | Derived table       |
-- | Need inner query to use current outer row   | Correlated subquery |
-- | Compare with at least one value from a list | `ANY`               |
-- | Compare with every value from a list        | `ALL`               |

-- One sentence to remember everything
-- ---------------------------------------
-- ONE answer → compare. 
-- MANY answers → IN/NOT IN. 
-- EXISTENCE → EXISTS/NOT EXISTS. 
-- Need grouped results as a table → derived table. 
-- Inner needs outer row → correlated.
-- ---------------------------------------------------

-- Practice Questions
-- =====================

-- Which pizza categories have total revenue greater than the overall average pizza sale price? 

-- inner- overall average pizza sale price
-- outer- pizza categories have total revenue greater than the overall average

SELECT
	pizza_category,
	SUM(total_price) AS total_revenue
FROM
	pizza_sales
GROUP BY
	pizza_category
HAVING
	total_revenue > (
	SELECT
		AVG(total_price) AS avg_price
	FROM
		pizza_sales);

/*==========================================================
| Question wording               | What to think           |
| ------------------------------ | ----------------------- |
| Average `total_price`          | `AVG(total_price)`      |
| Average quantity sold          | `AVG(quantity)`         |
| Average selling price          | `AVG(total_price)`      |
| Average **per pizza size**     | Group by size first     |
| Average **per category**       | Group by category first |
| Average **of category totals** | Group → SUM → AVG       |
| Average **of size totals**     | Group → SUM → AVG       |
| Average **by pizza type**      | Group by type first     |
==========================================================*/

-- Golden rule
-- ------------

-- If you're averaging the original column → ROW average.
-- If you're averaging something you first calculated for each group → GROUP avg -GROUP → calculate value → AVG(that value)

-- ----------------------------------------------------------------------------------------------------------

-- Which pizza sizes have a total quantity sold greater than the average quantity sold per pizza size?

-- inner- average quantity sold per pizza size (group avg)
-- outer- pizza sizes have a total quantity sold greater than the average quantity

SELECT
	pizza_size ,
	SUM(quantity) AS total_quantity
FROM
	pizza_sales
GROUP BY
	pizza_size
HAVING
	total_quantity
	>(
	SELECT
		AVG(total_quantity)
	FROM
		(
		SELECT
			pizza_size,
			SUM(quantity) AS total_quantity
		FROM
			pizza_sales
		GROUP BY
			pizza_size
		)
			AS size_totals
	  )
ORDER BY
	total_quantity DESC ;

-- IN --
-- ==========
-- Which pizza types belong to pizza categories that have sold more than 10,000 pizzas?

-- inner- pizza categories whose total quantity sold is greater than 10,000
-- outer- pizza types that belong to those qualifying categories

SELECT
	DISTINCT pizza_name_id,
	pizza_category
FROM
	pizza_sales
WHERE
	pizza_category IN (
	SELECT
		pizza_category
	FROM
		pizza_sales
	GROUP BY
		pizza_category
	HAVING
		SUM(quantity) > 10000
						) ;

-- IN    - is used when the subquery returns multiple possible values.
-- WHERE - checks whether the current row's value belongs to that returned list.

-- Which pizza types belong to categories whose total revenue is greater than ₹200,000?

-- inner- pizza categories whose total revenue is greater than 2,00,000
-- outer- pizza types that belong to those qualifying categories

SELECT
	DISTINCT pizza_name_id,
	pizza_category
FROM
	pizza_sales
WHERE
	pizza_category IN (
	SELECT
		pizza_category
	FROM
		pizza_sales
	GROUP BY
		pizza_category
	HAVING
		SUM(total_price) > 200000
						) ;

-- IN subquery = Inner query returns a LIST of values → Outer query checks whether its value is IN that list.
-- INNER → one value → > / < / =
-- INNER → many values → IN

-- Which pizza types belong to pizza sizes that have sold more than 10,000 units?

-- inner- pizza sizes that have sold more than 10,000 units
-- outer- pizza types that belong to those qualifying categories

SELECT
	DISTINCT pizza_name_id,
	pizza_size
FROM
	pizza_sales
WHERE
	pizza_size IN (
	SELECT
		pizza_size
	FROM
		pizza_sales
	GROUP BY
		pizza_size
	HAVING
		SUM(quantity) > 10000
						) ;

-- Which pizza types belong to pizza categories whose average quantity sold per record is greater than 2?

-- inner- pizza categories whose average quantity sold per record is greater than 2
-- outer- pizza types that belong to those qualifying categories

SELECT
	DISTINCT pizza_name_id,
	pizza_category
FROM
	pizza_sales
WHERE
	pizza_category IN (
	SELECT
		pizza_category
	FROM
		pizza_sales
	GROUP BY
		pizza_category
	HAVING
		AVG(quantity) > 2 
						) ;

-- Which pizza types belong to pizza categories whose average total_price is greater than ₹20?

-- inner- pizza categories whose average total_price is greater than ₹20
-- outer- pizza types that belong to those qualifying categories

SELECT
	DISTINCT pizza_name_id,
	pizza_category
FROM
	pizza_sales
WHERE
	pizza_category IN (
	SELECT
		pizza_category
	FROM
		pizza_sales
	GROUP BY
		pizza_category
	HAVING
		AVG(total_price) > 20 
							) ;

-- Which pizza categories have an average total_price greater than the overall average total_price of all pizza sales?
 
-- inner- overall average total_price of all pizza sales
-- outer- pizza categories that belong to those qualifying categories

SELECT
	pizza_category,
	ROUND(AVG(total_price), 2) AS avg_price
FROM
	pizza_sales
GROUP BY
	pizza_category
HAVING
	avg_price > (
	SELECT
		AVG(total_price)
	FROM
		pizza_sales 
					) ;

-- NOT IN --
-- ===========

-- Which pizza types do NOT belong to pizza categories whose total revenue is greater than ₹200,000?

-- inner- pizza categories whose total revenue is greater than ₹200,000
-- outer- pizza types do NOT belong to that belong to those qualifying categories

SELECT
	DISTINCT pizza_name_id,
	pizza_category
FROM
	pizza_sales
WHERE
	pizza_category NOT IN (
	SELECT
		pizza_category
	FROM
		pizza_sales
	GROUP BY
		pizza_category
	HAVING
		SUM(total_price) > 200000 
								);
-- EXISTS --
-- ===========

-- Which pizza categories have at least one pizza type with a total quantity sold greater than 1,000 units?

-- inner- total quantity for each pizza type that sold greater than 1,000 units
-- outer- categories have at least one of those pizza types

SELECT
	DISTINCT P1.pizza_category
FROM
	pizza_sales AS P1
WHERE
	EXISTS (
	SELECT
		1
	FROM
		pizza_sales AS P2
	GROUP BY
		P2.pizza_name_id,
		P2.pizza_category
	HAVING
		P2.pizza_category = P1.pizza_category
		AND
SUM(P2.quantity) > 1000 );

SELECT
	pizza_name_id,
	pizza_category,
	SUM(quantity) AS total_quantity
FROM
	pizza_sales
GROUP BY
	pizza_name_id,
	pizza_category
HAVING
	SUM(quantity) > 1000;

SELECT
	DISTINCT
    p1.pizza_category
FROM
	pizza_sales AS p1
WHERE
	EXISTS (
	SELECT
		1
	FROM
		pizza_sales AS p2
	WHERE
		p2.pizza_category = p1.pizza_category
);

/*==========================================================
-- EXISTS
-- = "At least ONE exists?" ✅

-- NOT EXISTS
-- = "NOT EVEN ONE exists?" ✅
==========================================================*/

-- Conditional Logic- CASE WHEN 
-- ================================

/*==========================================================
-- Note:-
-- SELECT
--    column1,
--    column2,
--    CASE
--        WHEN condition THEN result
--        ELSE result
--    END AS new_column
-- FROM table;
==========================================================*/

/*==========================================================
Query 61: Classify Pizza Sales by Quantity

Business Question:

Classify each pizza sale as 'High Quantity' if quantity is 3 or more, otherwise classify it as 'Low Quantity'.

Purpose:

Create a simple category based on the quantity sold in each pizza sale.

SQL Concepts Used:

- CASE WHEN
- ELSE
- END
- Column Alias
==========================================================*/

SELECT
	pizza_name_id,
	quantity,
	CASE
		WHEN quantity >= 3 THEN 'High Quantity'
		ELSE 'Low Quantity'
	END AS quantity_category
FROM
	pizza_sales;

/*==========================================================
Query 62: Classify Pizza Sales by Quantity Range

Business Question:

Classify each pizza sale as 'Low', 'Medium', or 'High' based on the quantity sold:
- Low → quantity is 1
- Medium → quantity is 2
- High → quantity is 3 or more

Purpose:

Create multiple business categories using different quantity conditions.

SQL Concepts Used:

- CASE WHEN
- Multiple WHEN conditions
- ELSE
- END
- Column Alias
==========================================================*/

SELECT
	pizza_name_id,
	quantity,
	CASE
		WHEN quantity >= 3 THEN 'High'
		WHEN quantity = 2 THEN 'Medium'
		ELSE 'Low'
	END AS quantity_category
FROM
	pizza_sales;

/*==========================================================
Query 63: Classify Sales by Revenue

Business Question:

Classify each pizza sale as 'High Revenue' if total_price is 30 or more, otherwise classify it as 'Low Revenue'.

Purpose:

Identify individual sales that generate relatively high revenue.

SQL Concepts Used:

- CASE WHEN
- ELSE
- END
- Column Alias
==========================================================*/

SELECT
	pizza_name_id,
	total_price,
	CASE
		WHEN total_price >= 30 THEN 'High Revenue'
		ELSE 'Low Revenue'
	END AS price_category
FROM
	pizza_sales;

/*==========================================================
Query 64: Classify Sales by Revenue Range

Business Question:

Classify each pizza sale as 'Low', 'Medium', or 'High' based on total_price:
- Low → less than 20
- Medium → 20 to 30
- High → greater than 30

Purpose:

Create revenue ranges to make individual sales easier to analyze.

SQL Concepts Used:

- CASE WHEN
- Multiple WHEN conditions
- ELSE
- END
- Column Alias
==========================================================*/

SELECT
	pizza_name_id,
	total_price,
	CASE
		WHEN total_price >= 30 THEN 'High'
		WHEN total_price between 20 and 30 THEN 'Medium'
		ELSE 'Low'
	END AS price_category
FROM
	pizza_sales;

/*==========================================================
Query 65: Classify Pizza Sales by Order Value

Business Question:

Classify each pizza sale as 'Small', 'Medium', or 'Large' based on total_price:
- Small → less than 15
- Medium → 15 to 25
- Large → greater than 25

Purpose:

Create simple order-value categories for business analysis.

SQL Concepts Used:

- CASE WHEN
- Multiple WHEN conditions
- BETWEEN
- ELSE
- END
- Column Alias
==========================================================*/

SELECT
	pizza_name_id,
	total_price,
	CASE
		WHEN total_price >= 25 THEN 'High'
		WHEN total_price between 15 and 25 THEN 'Medium'
		ELSE 'Low'
	END AS price_category
FROM
	pizza_sales;

/*==========================================================
Query 66: Classify Pizza Sales by Quantity and Revenue

Business Question:

Classify each pizza sale as 'High Value' when quantity is 3 or more AND total_price is 30 or more. 
Otherwise classify it as 'Regular Value'.

Purpose:

Identify sales that have both high quantity and high revenue.

SQL Concepts Used:

- CASE WHEN
- AND
- Multiple conditions
- ELSE
- END
- Column Alias
==========================================================*/

SELECT
	pizza_name_id,
	quantity,
	total_price,
	CASE
		WHEN quantity >= 3
		and total_price >= 30 THEN 'High Value'
		ELSE 'Regular Value'
	END AS value_category
FROM
	pizza_sales;

/*==========================================================
Query 67: Classify Pizza Sales by Quantity and Revenue

Business Question:

Classify each pizza sale as:
- 'High Value' if quantity is 3 or more AND total_price is 30 or more
- 'Medium Value' if quantity is 2 OR total_price is between 20 and 30
- 'Low Value' otherwise

Purpose:

Create multiple business categories using a combination of AND, OR, and CASE WHEN.

SQL Concepts Used:

- CASE WHEN
- AND
- OR
- BETWEEN
- Multiple WHEN conditions
- ELSE
- END
- Column Alias
==========================================================*/

SELECT
	pizza_name_id,
	quantity,
	total_price,
	CASE
		WHEN quantity >= 3
		and total_price >= 30 THEN 'High Value'
		WHEN quantity = 2
		or total_price between 20 and 30 THEN 'Medium Value'
		ELSE 'Low Value'
	END AS value_category
FROM
	pizza_sales;

/*====================================================================
Query Number: 68

Business Question:
Classify each pizza sale based on its pizza category:
- 'Classic' if pizza_category = 'Classic'
- 'Specialty' if pizza_category = 'Specialty'
- 'Other' for all other categories

Purpose:
Create business categories using CASE WHEN based on a text column.

SQL Concepts Used:
- CASE WHEN
- Text comparison
- ELSE
- END
- Column Alias
========================================================================*/

SELECT
	pizza_name_id,
	pizza_category,
	CASE
		WHEN pizza_category = 'Classic' THEN 'Classic'
		WHEN pizza_category = 'Specialty' THEN 'Specialty'
		ELSE 'Other'
	END AS category_type
FROM
	pizza_sales;

/*==================================================================================
Query Number: 69

Business Question:
Calculate the total revenue for each pizza category and classify the category as:
- 'High Revenue' if total revenue is greater than 200,000
- 'Medium Revenue' if total revenue is between 100,000 and 200,000
- 'Low Revenue' otherwise

Purpose:
Use CASE WHEN to classify aggregated results after GROUP BY.

SQL Concepts Used:
- SUM()
- GROUP BY
- CASE WHEN
- BETWEEN
- ELSE
- END
- Column Alias
- ORDER BY
========================================================================================*/

SELECT
	pizza_category,
	SUM(total_price) AS total_revenue,
	CASE
		WHEN SUM(total_price) >= 200000 THEN 'High Revenue'
		WHEN SUM(total_price) between 100000 and 200000 THEN 'Medium Revenue'
		ELSE 'Low Revenue'
	END AS revenue_type
FROM
	pizza_sales
GROUP BY
	pizza_category
ORDER BY 
	total_revenue DESC ;

-- Note:-
-- ========== 
-- Don't use alias names while using inside "WHEN"
-- eg:- don't use alias name like 'total_revenue' instead use SUM(total_price)

/*=====================================================================================
Query Number: 70

Business Question:
For each pizza category, count the number of pizza sales and classify the category as:

- 'High Activity' if the number of sales is greater than 5,000
- 'Medium Activity' if the number of sales is between 3,000 and 5,000
- 'Low Activity' otherwise

Purpose:
Classify pizza categories based on the number of sales they have.

SQL Concepts Used:
- COUNT()
- GROUP BY
- CASE WHEN
- BETWEEN
- ELSE
- END
- Column Alias
- ORDER BY
==========================================================================================*/

SELECT
	pizza_category,
	COUNT(*) AS total_sales,
	CASE
		WHEN COUNT(*) > 5000 THEN 'High Activity'
		WHEN COUNT(*) between 3000 and 5000 THEN 'Medium Activity'
		ELSE 'Low Activity'
	END AS activity_level
FROM
	pizza_sales
GROUP BY
	pizza_category
ORDER BY 
	total_sales DESC ;

/*====================================================================================
Query Number: 71

Business Question:
For each pizza category, calculate:
- Total sales
- Number of High Value sales

A High Value sale is one where:
- quantity >= 3
- AND total_price >= 30

Purpose:
Use CASE WHEN inside an aggregate function to count records that meet a condition.

SQL Concepts Used:
- COUNT()
- SUM()
- CASE WHEN
- AND
- GROUP BY
- Conditional Aggregation
- Column Alias

Small Note:
This is called Conditional Aggregation.
               -------------------------
Instead of filtering rows with WHERE, we use CASE WHEN inside COUNT() or SUM() to count only 
the rows that meet a condition.
=========================================================================================*/

SELECT
	pizza_category,
	COUNT(*) AS total_sales,
	COUNT(
        CASE
            WHEN quantity >= 3 AND total_price >= 30 THEN 'High Sale Value'
        END
    ) AS high_value_sales
FROM
	pizza_sales
GROUP BY
	pizza_category
ORDER BY
	high_value_sales DESC;
		
/*=============================================
-- Note:-
 
 COUNT(*) 
→ counts every row

COUNT(CASE WHEN condition THEN value END)
→ counts only rows where the condition is TRUE
		
===============================================*/		

-- Window Functions 
-- =================

/*==============================================================================================================
Difference Between GROUP BY and OVER()
--------------------------------------
Feature	           GROUP BY	                               OVER() Window Function
--------          ----------                              ------------------------
Purpose	         Groups rows to calculate summaries	  Calculates values across related rows
Rows in output	 Usually reduces the number of rows	  Keeps individual rows visible
Example	         Total revenue per category	          Each sale plus its category's total revenue
Common use	     Summary reports	                  Rankings, comparisons, running totals

------------------------
| Easy way to remember |
------------------------
- GROUP BY     = Summarize rows.
- OVER()       = Calculate across rows without losing individual rows.
- PARTITION BY = Divide rows into groups for a window function.

Important:
=========== 
OVER() does not always require PARTITION BY. 
For example, SUM(total_price) OVER() calculates the overall total across all rows.

==============================================================================================================*/	

/*==================================================================================================================
Query Number: 73

Business Question:
For every row in the pizza_sales table, display the pizza category, pizza name ID, total price, and the total revenue generated by that pizza category.

Purpose:
Calculate category-level revenue while keeping every individual sale visible.

SQL Concepts Used:
SUM()
OVER()
PARTITION BY
=====================================================================================================================*/

SELECT
	pizza_name_id,
	pizza_category,
	total_price,
	SUM(total_price) OVER (
        PARTITION BY pizza_category
    ) AS category_revenue
FROM
	pizza_sales;

/*==========================================================================
DIFFERENCE BETWEEN RANK() AND DENSE_RANK()

1. RANK()
- Assigns a ranking number based on the specified order.
- If two rows have the same value, they receive the same rank.
- The next rank is skipped after a tie.

2. DENSE_RANK()
- Assigns a ranking number based on the specified order.
- If two rows have the same value, they receive the same rank.
- The next rank is NOT skipped after a tie.

Example:

Revenue      RANK()      DENSE_RANK()
260000          1             1
220000          2             2
220000          2             2
180000          4             3
150000          5             4

SQL SYNTAX:

RANK() OVER (
    ORDER BY total_revenue DESC
)

DENSE_RANK() OVER (
    ORDER BY total_revenue DESC
)

ORDER BY total_revenue DESC:
- DESC means highest revenue gets the first rank.

KEY DIFFERENCE:
RANK() skips ranks after ties.
DENSE_RANK() does not skip ranks after ties.

WHEN TO USE:
- Use RANK() when you want competition-style rankings.
- Use DENSE_RANK() when you want consecutive rankings without gaps.

IMPORTANT:
Both functions assign the same rank to tied values.
The difference appears in the ranking numbers that follow a tie.
============================================================================*/

/*=============================================================================================================================================
Query Number: 74

Business Question:
Display each pizza category's total revenue and rank the categories from highest to lowest revenue.

Purpose:
Rank pizza categories based on their total revenue.

SQL Concepts Used:
SUM()
GROUP BY
DENSE_RANK()
OVER()
ORDER BY
Subquery
================================================================================================================================================*/

SELECT
    pizza_category,
    total_revenue,
    DENSE_RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM (
    SELECT
        pizza_category,
        SUM(total_price) AS total_revenue
    FROM pizza_sales
    GROUP BY pizza_category
) AS category_totals;

/*================================================================================
Query Number: 75

Business Question:
Calculate the total revenue generated by each pizza_name_id and assign a rank to each pizza from highest to lowest revenue.

Purpose:
Identify the highest-revenue pizzas and practise ranking individual pizza products.

SQL Concepts Used:
SUM()
GROUP BY
RANK()
OVER()
Subquery
========================================================================================*/

SELECT
	pizza_name_id,
	total_revenue ,
	RANK() OVER (
	ORDER BY total_revenue DESC) AS revenue_rank
FROM
	(
	SELECT
		pizza_name_id,
		SUM(total_price) AS total_revenue
	FROM
		pizza_sales ps
	GROUP BY
		pizza_name_id ) AS pizza_total;

/*========================================================================================
Query Number: 76

Business Question:
Identify the top 3 pizzas based on total revenue generated.

Purpose:
Find the best-performing pizzas by revenue.

SQL Concepts Used:
SUM()
GROUP BY
DENSE_RANK()
OVER()
Subqueries
WHERE
============================================================================================*/

SELECT
    pizza_name_id,
    total_revenue,
    revenue_rank
FROM (
    SELECT
        pizza_name_id,
        total_revenue,
        DENSE_RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM (
        SELECT
            pizza_name_id,
            SUM(total_price) AS total_revenue
        FROM pizza_sales
        GROUP BY pizza_name_id
    ) AS pizza_total
) AS ranked_pizzas
WHERE revenue_rank <= 3;

/*========================================================================
Query Number: 77

Business Question:
For each pizza, display its total revenue alongside
the total revenue of its pizza category.

Purpose:
Understand how an individual pizza's revenue compares
with the overall revenue of its category.

SQL Concepts Used:
SUM()
GROUP BY
Window Functions
OVER()
PARTITION BY
Subqueries
=============================================================================*/

SELECT
	pizza_name_id,
	pizza_category,
	pizza_revenue,
	SUM(pizza_revenue) OVER (
            PARTITION BY pizza_category
        ) AS category_revenue
FROM
	(
	SELECT
		pizza_name_id,
		pizza_category,
		SUM(total_price) AS pizza_revenue
	FROM
		pizza_sales
	GROUP BY
		pizza_name_id,
		pizza_category) AS pizza_totals
ORDER BY
	pizza_category,
	pizza_revenue DESC ;

/*======================================================================
Query Number: 78

Business Question:
Calculate the percentage contribution of each pizza's
revenue to its category's total revenue.

Purpose:
Identify how much each pizza contributes to its
category's overall revenue.

SQL Concepts Used:
SUM()
GROUP BY
Window Functions
OVER()
PARTITION BY
Subqueries
ROUND()
Arithmetic Operations
==============================================================================*/

SELECT
    pizza_name_id,
    pizza_category,
    pizza_revenue,
    category_revenue,
    ROUND((pizza_revenue / category_revenue) * 100, 2)
        AS revenue_percentage
FROM (
    SELECT
        pizza_name_id,
        pizza_category,
        pizza_revenue,
        SUM(pizza_revenue) OVER (
            PARTITION BY pizza_category
        ) AS category_revenue
    FROM (
        SELECT
            pizza_name_id,
            pizza_category,
            SUM(total_price) AS pizza_revenue
        FROM pizza_sales
        GROUP BY
            pizza_name_id,
            pizza_category
    ) AS pizza_totals
) AS category_totals
ORDER BY
    pizza_category,
    revenue_percentage DESC;

/*======================================================================
Query Number: 79

Business Question:
Rank pizzas by total revenue within each pizza category,
from highest to lowest.

Purpose:
Identify the best-performing pizzas within each category.

SQL Concepts Used:
SUM()
GROUP BY
RANK()
OVER()
PARTITION BY
Subqueries
==============================================================================*/

SELECT
	pizza_name_id,
	pizza_category,
	pizza_revenue,
	RANK () OVER (
            PARTITION BY pizza_category
ORDER BY
	pizza_revenue DESC
        ) AS revenue_rank
FROM
	(
	SELECT
		pizza_name_id,
		pizza_category,
		SUM(total_price) AS pizza_revenue
	FROM
		pizza_sales
	GROUP BY
		pizza_name_id,
		pizza_category 
) AS pizza_totals
ORDER BY
	pizza_revenue DESC;

/*======================================================================
Query Number: 80

Business Question:
Calculate the cumulative revenue generated over time,
using each sale's order date.

Purpose:
Track how revenue accumulates from one date to the next.

SQL Concepts Used:
SUM()
OVER()
ORDER BY
Window Functions
==============================================================================*/

SELECT
	order_date,
	daily_revenue,
	SUM(daily_revenue) 
OVER (
	ORDER BY order_date ) AS running_revenue
FROM
	(
	SELECT
		order_date,
		SUM(total_price) AS daily_revenue
	FROM
		pizza_sales
	GROUP BY
		order_date
) AS daily_totals
ORDER BY
	order_date ASC ;

/*======================================================================
Query Number: 81

Business Question:
Calculate the 3-day moving average of daily revenue.

Purpose:
Smooth out daily revenue fluctuations and identify
short-term revenue trends.

SQL Concepts Used:
SUM()
GROUP BY
AVG()
Window Functions
OVER()
ORDER BY
ROWS BETWEEN
Subqueries
==============================================================================*/

SELECT
	order_date,
	daily_revenue,
	ROUND (AVG(daily_revenue) OVER (
ORDER BY
	order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW ),
	2) AS moving_avg_revenue
FROM
	(
	SELECT
		order_date,
		SUM(total_price) AS daily_revenue
	FROM
		pizza_sales
	GROUP BY
		order_date
) AS daily_totals
ORDER BY
	order_date ASC ;

/*===========================================================================
Query Number: 82

Business Question:
Compare each pizza's revenue with the average revenue of all pizzas.

Purpose:
Identify pizzas generating above-average or
below-average revenue.

SQL Concepts Used:
SUM()
GROUP BY
AVG()
Window Functions
OVER()
Subqueries
ROUND()
==============================================================================*/

SELECT
	pizza_name_id,
	pizza_revenue,
	ROUND(AVG(pizza_revenue) 
OVER (),2) AS averge_pizza_revenue
FROM
	(
	SELECT
		pizza_name_id,
		SUM(total_price) AS pizza_revenue
	FROM
		pizza_sales
	GROUP BY pizza_name_id
		)
AS pizza_totals
ORDER BY
	pizza_name_id ;

/*===========================================================================
Query Number: 83

Business Question:
Classify each pizza as Above Average or Below Average
based on its total revenue compared with the overall
average revenue of all pizzas.

Purpose:
Identify pizzas performing above or below the
average revenue level.

SQL Concepts Used:
SUM()
GROUP BY
AVG()
OVER()
CASE WHEN
Subqueries
===============================================================================*/

SELECT
	pizza_name_id,
	pizza_revenue,
	average_pizza_revenue,
	CASE
		WHEN pizza_revenue > average_pizza_revenue THEN "Above Average"
		WHEN pizza_revenue = average_pizza_revenue THEN "Average"
		ELSE "Below Average"
	END AS revenue_performance
FROM
	(
	SELECT
		pizza_name_id,
		pizza_revenue,
		ROUND (AVG(pizza_revenue) OVER (),
		2) AS average_pizza_revenue
	FROM
		(
		SELECT
			pizza_name_id,
			SUM(total_price) AS pizza_revenue
		FROM
			pizza_sales
		GROUP BY
			pizza_name_id
) AS pizza_totals 
) AS pizza_average
ORDER BY
	pizza_name_id;

/*===================================================================================
Query Number: 84

Business Question:
How does each pizza's revenue compare with the previous pizza's revenue
when pizzas are ordered from highest to lowest revenue?

Purpose:
Compare each pizza's revenue with the revenue of the pizza ranked immediately
above it.

SQL Concepts Used:
SUM()
GROUP BY
LAG()
OVER()
Subqueries
ORDER BY
======================================================================================*/

SELECT
	pizza_name_id,
	pizza_revenue ,
	LAG(pizza_revenue) OVER (ORDER BY pizza_revenue DESC) AS previous_pizza_revenue
FROM
	(
	SELECT
		pizza_name_id,
		SUM(total_price) AS pizza_revenue
	FROM
		pizza_sales
	GROUP BY
		pizza_name_id) AS pizza_totals
ORDER BY
	pizza_revenue DESC ;

/*======================================================================================
Query Number: 85

Business Question:
What is the revenue difference between each pizza and the
previous pizza when pizzas are ordered from highest to lowest revenue?

Purpose:
Measure the revenue gap between consecutive pizzas.

SQL Concepts Used:
SUM()
GROUP BY
LAG()
OVER()
Subqueries
Arithmetic subtraction
ORDER BY
==========================================================================================*/

SELECT
	pizza_name_id,
	pizza_revenue ,
	LAG(pizza_revenue) OVER (ORDER BY pizza_revenue DESC) AS previous_pizza_revenue,
	pizza_revenue - LAG(pizza_revenue) OVER (ORDER BY pizza_revenue DESC) AS revenue_difference
FROM
	(
	SELECT
		pizza_name_id,
		SUM(total_price) AS pizza_revenue
	FROM
		pizza_sales
	GROUP BY
		pizza_name_id) AS pizza_totals
ORDER BY
	pizza_revenue DESC ;

/*=============================================================================
Query Number: 86

Business Question:
What is the revenue of the next pizza when pizzas are
ordered from highest to lowest revenue?

Purpose:
Compare each pizza with the next pizza in the revenue ranking.

SQL Concepts Used:
SUM()
GROUP BY
LEAD()
OVER()
Subqueries
ORDER BY
==================================================================================*/

SELECT
	pizza_name_id,
	pizza_revenue ,
	LEAD(pizza_revenue) OVER (ORDER BY pizza_revenue DESC) AS next_pizza_revenue
FROM
	(
	SELECT
		pizza_name_id,
		SUM(total_price) AS pizza_revenue
	FROM
		pizza_sales
	GROUP BY
		pizza_name_id) AS pizza_totals
ORDER BY
	pizza_revenue DESC ;

/*====================================================================================
Query Number: 87

Business Question:
What is the revenue difference between each pizza and the
next pizza when pizzas are ordered from highest to lowest revenue?

Purpose:
Measure the revenue gap between consecutive pizzas.

SQL Concepts Used:
SUM()
GROUP BY
LEAD()
OVER()
Subqueries
Arithmetic subtraction
ORDER BY

Expected Output Columns:
pizza_name_id
pizza_revenue
next_pizza_revenue
revenue_difference

Small Note:
INNER QUERY: Calculate total revenue for each pizza.
OUTER QUERY: Retrieve the next pizza's revenue and subtract
it from the current pizza's revenue.
==========================================================================================*/

SELECT
	pizza_name_id,
	pizza_revenue ,
	LEAD(pizza_revenue) OVER (ORDER BY pizza_revenue DESC) AS next_pizza_revenue,
	pizza_revenue - LEAD(pizza_revenue) OVER (ORDER BY pizza_revenue DESC) AS revenue_difference
FROM
	(
	SELECT
		pizza_name_id,
		SUM(total_price) AS pizza_revenue
	FROM
		pizza_sales
	GROUP BY
		pizza_name_id) AS pizza_totals
ORDER BY
	pizza_revenue DESC ;

-- CTE (Common Table Expression)
-- =================================

/*============================================================================================================================

DEFINITION:
A CTE is a temporary named result set created using WITH.
It makes complex SQL queries easier to read, understand, and maintain.

SYNTAX:

WITH cte_name AS (
    SELECT column_name, AGGREGATE_FUNCTION(column_name)
    FROM table_name
    GROUP BY column_name
)
SELECT *
FROM cte_name;

KEY POINTS:
1. WITH is used to define a CTE.
2. cte_name is the temporary name given to the query result.
3. The main query uses the CTE like a table.
4. A CTE exists only for the single SQL statement in which it is defined.
5. CTEs can replace subqueries and can improve readability.
6. Multiple CTEs can be defined in one WITH clause.

================================================================================================================================*/
/*
========================================================
CONCEPT: SUBQUERIES VS CTEs
========================================================

1. SUBQUERY
-----------

DEFINITION:
A subquery is a query written inside another SQL query.
It provides an intermediate result that the outer query uses.

PRACTICAL USE:
- Compare a value with an average or total.
- Filter records based on another query's result.
- Filter aggregated results.
- Check whether matching records exist using EXISTS.
- Find records above or below a calculated value.

WHEN TO USE:
Use a subquery when the intermediate calculation is
straightforward and does not require several named steps.

EXAMPLE:
Find pizzas whose revenue is greater than the average
revenue of all pizzas.

SELECT
    pizza_name_id,
    SUM(total_price) AS pizza_revenue
FROM pizza_sales
GROUP BY pizza_name_id
HAVING SUM(total_price) > (
    SELECT AVG(pizza_revenue)
    FROM (
        SELECT SUM(total_price) AS pizza_revenue
        FROM pizza_sales
        GROUP BY pizza_name_id
    ) AS pizza_totals
);


2. CTE (COMMON TABLE EXPRESSION)
--------------------------------

DEFINITION:
A CTE is a temporary named query result created using WITH.
The main query can use the CTE as if it were a table.

PRACTICAL USE:
- Break complex queries into logical steps.
- Give intermediate results meaningful names.
- Make long queries easier to read and maintain.
- Reuse a named intermediate result within a statement.
- Organise multi-stage business analysis.

WHEN TO USE:
Use a CTE when a query involves multiple steps or when
nested subqueries become difficult to understand.

EXAMPLE:
Calculate the total revenue for each pizza.

WITH pizza_totals AS (
    SELECT
        pizza_name_id,
        SUM(total_price) AS pizza_revenue
    FROM pizza_sales
    GROUP BY pizza_name_id
)
SELECT
    pizza_name_id,
    pizza_revenue
FROM pizza_totals
ORDER BY pizza_revenue DESC;


3. SUBQUERY VS CTE
------------------

SUBQUERY:
- Query is nested inside another query.
- Useful for direct calculations and comparisons.
- Can become difficult to read when deeply nested.

CTE:
- Defined before the main query using WITH.
- Gives intermediate results a meaningful name.
- Useful for multi-step and complex analysis.
- Often makes SQL easier to read and maintain.

IMPORTANT:
Both techniques can solve the same business problem.
Neither technique is always better than the other.


4. WHICH ONE SHOULD I USE?
---------------------------

Simple nested calculation:                             SUBQUERY

Compare a value with an average:                       SUBQUERY OR CTE

Check whether matching records exist:                  EXISTS SUBQUERY

Complex analysis with multiple steps:                  CTE

Use an intermediate result multiple times:             CTE CAN BE MORE CONVENIENT

Top-performing records using several calculations:     CTE OR SUBQUERY


5. PERFORMANCE
---------------

A CTE is NOT automatically faster than a subquery.

Performance depends on:
- Query structure
- Dataset size
- Indexes
- MySQL execution plan

Use EXPLAIN to investigate query performance when needed.


6. KEY TAKEAWAY
---------------

SUBQUERY:
Use it when a query inside another query is the clearest
way to perform a calculation or comparison.

CTE:
Use it when naming and separating intermediate steps makes
the overall query easier to understand.

A good data analyst chooses the technique that makes the
query clear, correct, maintainable, and efficient.
========================================================*/

/*=======================================================================================
Query Number: 88

Business Question:
Which pizzas generate the highest total revenue?

Purpose:
Calculate the total revenue generated by each pizza and
display the results from highest to lowest revenue.

SQL Concepts Used:
WITH
CTE
SUM()
GROUP BY
ORDER BY
=========================================================================================*/

WITH pizza_totals AS (
SELECT
	pizza_name_id,
	SUM(total_price) AS pizza_revenue
FROM
	pizza_sales
GROUP BY
	pizza_name_id )
SELECT
	pizza_name_id,
	pizza_revenue
FROM
	pizza_totals
ORDER BY
	pizza_revenue DESC ;

/*===========================================================================
Query Number: 89

Business Question:
Which pizzas generated total revenue greater than 20,000?

Purpose:
Identify pizzas whose total revenue exceeds a specified threshold.

SQL Concepts Used:
WITH
CTE
SUM()
GROUP BY
WHERE
ORDER BY

Expected Output Columns:
pizza_name_id
pizza_revenue

Small Note:
CTE: Calculate total revenue for each pizza.
MAIN QUERY: Filter the CTE results using WHERE.
======================================================================================*/

WITH pizza_totals AS (
SELECT
	pizza_name_id,
	SUM(total_price)AS pizza_revenue
FROM
	pizza_sales
GROUP BY
	pizza_name_id)
SELECT
	pizza_name_id,
	pizza_revenue
FROM
	pizza_totals
WHERE
	pizza_revenue > 20000
ORDER BY
	pizza_revenue DESC ;

/*===================================================================================
Query Number: 90

Business Question:
Which pizzas generated more revenue than the average revenue per pizza?

Purpose:
Identify pizzas whose total revenue is higher than the average
total revenue across all pizzas.

SQL Concepts Used:
WITH
CTE
SUM()
GROUP BY
AVG()
Subquery
WHERE
ORDER BY
======================================================================================*/

WITH pizza_totals AS (
SELECT
	pizza_name_id,
	SUM(total_price) AS pizza_revenue
FROM
	pizza_sales
GROUP BY
	pizza_name_id)
SELECT
	pizza_name_id,
	pizza_revenue
FROM
	pizza_totals
WHERE
	pizza_revenue > (
	SELECT
		AVG(pizza_revenue) AS average_pizza_revenue
	FROM
		pizza_totals)
ORDER BY
	pizza_revenue ;

-- Note:
-- ------
/* When you want to compare each row against an aggregate value calculated across multiple rows, 
a subquery can provide that comparison value */

/*===========================================================================================================
Query Number: 91

Business Question:
What is the total revenue generated by each pizza category,
considering only pizzas with revenue greater than 20,000?

Purpose:
Analyse category revenue using only pizzas that exceed
the specified individual pizza revenue threshold.

SQL Concepts Used:
WITH
CTE
SUM()
GROUP BY
HAVING
JOIN
WHERE
ORDER BY
==============================================================================================================*/

WITH pizza_totals AS (
SELECT
	pizza_name_id,
	pizza_category,
	SUM(total_price) AS pizza_revenue
FROM
	pizza_sales
GROUP BY
	pizza_name_id,
	pizza_category)
SELECT
	pizza_category,
	SUM(pizza_revenue) AS category_revenue
FROM
	pizza_totals
WHERE
	pizza_revenue > 20000
GROUP BY
	pizza_category
ORDER BY
	category_revenue DESC ;

/*===================================================================================
Query Number: 92

Business Question:
Which pizza categories have total revenue greater than the average revenue per category?

Purpose:
Identify categories that perform above the average
category revenue.

SQL Concepts Used:
WITH
CTE
SUM()
GROUP BY
AVG()
Subquery
WHERE
ORDER BY
===========================================================================================*/

WITH category_totals AS (
SELECT
	pizza_category,
	SUM(total_price) AS category_revenue
FROM
	pizza_sales
GROUP BY
	pizza_category)
SELECT
	pizza_category,
	category_revenue
FROM
	category_totals
WHERE
	category_revenue > (
	SELECT
		AVG(category_revenue)
	FROM
		category_totals )
ORDER BY
	category_revenue DESC ;

/*
Remember this distinction
------------------------------
- CTE: Calculates total revenue for each category.
- Subquery: Calculates the average of those category totals.
- Main query: Returns only categories above that average.
*/

/*==============================================================================================
Query Number: 93

Business Question:
How can we classify each pizza category as High, Medium,
or Low Revenue based on its total revenue?

Purpose:
Segment pizza categories into revenue performance groups.

SQL Concepts Used:
WITH
CTE
SUM()
GROUP BY
CASE WHEN
ORDER BY
==================================================================================================*/

WITH category_totals AS (
SELECT
	pizza_category,
	SUM(total_price) AS category_revenue
FROM
	pizza_sales
GROUP BY
	pizza_category)
SELECT
	pizza_category,
	category_revenue,
	CASE
		WHEN category_revenue >= 200000 THEN "High Revenue"
		WHEN category_revenue >=150000 THEN "Medium Revenue"
		ELSE "Low Revenue"
	END AS revenue_category
FROM
	category_totals
ORDER BY
	category_revenue DESC ;

/*==============================================================================
Query Number: 94

Business Question:
What is the total revenue and total quantity sold for each pizza?

Purpose:
Analyse revenue and sales volume together for each pizza.

SQL Concepts Used:
WITH
Multiple CTEs
SUM()
GROUP BY
JOIN
ORDER BY
==================================================================================*/

WITH pizza_totals AS (
SELECT
	pizza_name_id,
	SUM(total_price) AS pizza_revenue
FROM
	pizza_sales
GROUP BY
	pizza_name_id ),
quantity_totals AS (
SELECT
	pizza_name_id,
	SUM(quantity) AS pizza_quantity
FROM
	pizza_sales
GROUP BY
	pizza_name_id )
SELECT
	pizza_totals.pizza_name_id,
	pizza_totals.pizza_revenue,
	quantity_totals.pizza_quantity
FROM
	pizza_totals
JOIN quantity_totals ON
	pizza_totals.pizza_name_id = quantity_totals.pizza_name_id
ORDER BY
	pizza_totals.pizza_revenue;

/*==================================================================================
Query Number: 95

Business Question:
What percentage of total sales revenue does each pizza contribute?

Purpose:
Identify each pizza's contribution to overall business revenue.

SQL Concepts Used:
WITH
Multiple CTEs
SUM()
GROUP BY
JOIN
ROUND()
Percentage Calculation
ORDER BY
====================================================================================*/

WITH pizza_totals AS (
SELECT
	pizza_name_id,
	SUM(total_price) AS pizza_revenue
FROM
	pizza_sales
GROUP BY
	pizza_name_id),
overall_totals AS (
SELECT
	SUM(total_price) AS total_revenue
FROM
	pizza_sales)
SELECT
	pizza_totals.pizza_name_id,
	pizza_totals.pizza_revenue,
	overall_totals.total_revenue,
	ROUND(pizza_totals.pizza_revenue / overall_totals.total_revenue * 100, 2) AS revenue_percentage
FROM
	pizza_totals
CROSS JOIN overall_totals
ORDER BY
	revenue_percentage DESC ;

/*=================================================================================================
Query Number: 96

Business Question:
What percentage of its category's total revenue did each pizza contribute?

Purpose:
Compare individual pizza revenue with the revenue of its category.

SQL Concepts Used:
WITH
Multiple CTEs
SUM()
GROUP BY
JOIN
ROUND()
Percentage Calculation
====================================================================================================*/

WITH pizza_totals AS (
SELECT
	pizza_name_id,
	pizza_category,
	SUM(total_price) AS pizza_revenue
FROM
	pizza_sales
GROUP BY
	pizza_name_id,
	pizza_category),
category_totals AS (
SELECT
	pizza_category,
	SUM(total_price) AS category_revenue
FROM
	pizza_sales
GROUP BY
	pizza_category)
SELECT
	pizza_totals.pizza_name_id,
	pizza_totals.pizza_category ,
	pizza_totals.pizza_revenue ,
	category_totals.category_revenue,
	ROUND(pizza_totals.pizza_revenue / category_totals.category_revenue * 100, 2) AS revenue_percentage
FROM
	pizza_totals
JOIN category_totals ON
	pizza_totals.pizza_category = category_totals.pizza_category
ORDER BY
	revenue_percentage DESC ;

/*============================================================================================================================
Query Number: 97

Business Question:
For each pizza, what is its total revenue and its rank within its pizza category based on revenue?

Purpose:
Identify the highest-revenue pizzas within each category by calculating total revenue for each pizza and ranking pizzas 
from highest to lowest revenue within their respective categories.

SQL Concepts Used:
CTE (WITH)
SUM()
GROUP BY
DENSE_RANK()
OVER()
PARTITION BY
ORDER BY
============================================================================================================================*/

WITH pizza_totals AS (
SELECT
	pizza_name_id,
	pizza_category,
	SUM(total_price) AS pizza_revenue
FROM
	pizza_sales
GROUP BY
	pizza_name_id,
	pizza_category)
SELECT
	pizza_name_id,
	pizza_category,
	pizza_revenue,
	DENSE_RANK () OVER (PARTITION BY pizza_category
ORDER BY
	pizza_revenue DESC) AS revenue_rank
FROM
	pizza_totals ;

/*=====================================================================================================================
Query Number: 98

Business Question:
For each pizza category, identify the top 3 pizzas based on total revenue.

Purpose:
Find the highest-revenue pizzas in each category to understand which products contribute most to category sales.

SQL Concepts Used:
CTE (WITH)
SUM()
GROUP BY
DENSE_RANK()
OVER()
PARTITION BY
Subquery or an additional CTE
WHERE

Remember:
You cannot filter a window-function alias in the WHERE clause at the same query level where it is created. 
Use an additional CTE or subquery to filter the ranks.
========================================================================================================================*/

WITH pizza_totals AS (
SELECT
	pizza_name_id,
	pizza_category,
	SUM(total_price) AS pizza_revenue
FROM
	pizza_sales
GROUP BY
	pizza_name_id,
	pizza_category),
pizza_ranks AS (
SELECT
	pizza_name_id,
	pizza_category,
	pizza_revenue,
	DENSE_RANK () OVER (PARTITION BY pizza_category
ORDER BY
	pizza_revenue DESC) AS revenue_rank
FROM
	pizza_totals)
SELECT
	*
FROM
	pizza_ranks
WHERE
	revenue_rank <= 3;

/*================================================================================================================
Query Number: 99

Business Question:
For each pizza, calculate its total revenue, its rank within its pizza category, 
and the percentage of its category's total revenue that it contributes.

Purpose:
Identify high-performing pizzas and measure their contribution to category revenue.

SQL Concepts Used:
CTE (WITH)
SUM()
GROUP BY
DENSE_RANK()
Window Functions
PARTITION BY
JOIN
ROUND()
================================================================================================================*/

WITH pizza_totals AS (
SELECT
	pizza_name_id,
	pizza_category,
	SUM(total_price) AS pizza_revenue
FROM
	pizza_sales
GROUP BY
	pizza_name_id,
	pizza_category),
category_totals AS (
SELECT
	pizza_category,
	SUM(total_price) AS category_revenue
FROM
	pizza_sales
GROUP BY
	pizza_category),
pizza_ranks AS (
SELECT
	pizza_totals.pizza_name_id,
	pizza_totals.pizza_category ,
	pizza_totals.pizza_revenue ,
	DENSE_RANK () OVER (PARTITION BY pizza_category ORDER BY pizza_revenue DESC) AS revenue_rank
FROM
	pizza_totals)
SELECT
	pizza_ranks.pizza_name_id,
	pizza_ranks.pizza_category ,
	pizza_ranks.pizza_revenue ,
	pizza_ranks.revenue_rank,
	category_totals.category_revenue,
	ROUND(pizza_ranks.pizza_revenue / category_totals.category_revenue * 100, 2) AS revenue_percentage
FROM
	pizza_ranks 
JOIN category_totals ON
	pizza_ranks.pizza_category = category_totals.pizza_category
ORDER BY
	revenue_percentage DESC ;

/*=================================================================================================================
Query Number: 100

Business Question:
Identify the top 3 highest-revenue pizzas within each pizza category, showing each pizza's total revenue, 
its rank within the category, and its percentage contribution to category revenue.

Purpose:
Create a category-level performance analysis to identify the best-performing pizzas 
and understand their contribution to total category revenue.

SQL Concepts Used:
CTE (WITH)
SUM()
GROUP BY
DENSE_RANK()
Window Functions
PARTITION BY
JOIN
ROUND()
WHERE

Expected Output Columns:
1. pizza_name_id
2. pizza_category
3. pizza_revenue
4. revenue_rank
5. category_revenue
6. revenue_percentage

Small Note:
1. Calculate total revenue for each pizza.
2. Calculate total revenue for each category.
3. Rank pizzas within each category.
4. Calculate each pizza's percentage contribution to category revenue.
5. Display only ranks 1, 2, and 3.
6. Sort the final results by pizza_category and revenue_rank.

Remember:
Use an additional CTE if you need to filter the ranking results.
Window-function results cannot be filtered in the WHERE clause at the same query level where they are calculated.
=====================================================================================================================*/

WITH pizza_totals AS (
SELECT
	pizza_name_id,
	pizza_category,
	SUM(total_price) AS pizza_revenue
FROM
	pizza_sales
GROUP BY
	pizza_name_id,
	pizza_category),
category_totals AS (
SELECT
	pizza_category,
	SUM(total_price) AS category_revenue
FROM
	pizza_sales
GROUP BY
	pizza_category),
pizza_ranks AS (
SELECT
	pizza_totals.pizza_name_id,
	pizza_totals.pizza_category ,
	pizza_totals.pizza_revenue ,
	DENSE_RANK () OVER (PARTITION BY pizza_category ORDER BY pizza_revenue DESC) AS revenue_rank
FROM
	pizza_totals)
SELECT
	pizza_ranks.pizza_name_id,
	pizza_ranks.pizza_category ,
	pizza_ranks.pizza_revenue ,
	pizza_ranks.revenue_rank,
	category_totals.category_revenue,
	ROUND(pizza_ranks.pizza_revenue / category_totals.category_revenue * 100, 2) AS revenue_percentage
FROM
	pizza_ranks 
JOIN category_totals ON
	pizza_ranks.pizza_category = category_totals.pizza_category
WHERE
	revenue_rank <= 3
ORDER BY
    pizza_category,
    revenue_rank;