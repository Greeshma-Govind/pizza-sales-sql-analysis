# Pizza Sales SQL Analysis

## Project Overview
This project analyzes pizza sales data using MySQL to explore sales performance, product contribution, ordering patterns, and revenue trends. It demonstrates practical SQL techniques used in data analysis and business reporting.

## Project Objectives
- Evaluate overall sales performance.
- Identify top- and bottom-performing pizza products.
- Compare revenue and quantity sold across pizza categories and sizes.
- Explore hourly order patterns and revenue.
- Calculate revenue contribution percentages.
- Apply SQL techniques to answer business questions.

## Dataset
The dataset contains pizza sales transaction records with fields including:

- `order_id`
- `pizza_name_id`
- `pizza_category`
- `pizza_size`
- `quantity`
- `total_price`
- `order_date`
- `order_time`
- `order_day`

## Tools Used
- MySQL
- DBeaver
- GitHub

## SQL Concepts Demonstrated
- SELECT, WHERE, ORDER BY, and LIMIT
- Aggregate functions: COUNT(), SUM(), AVG(), MIN(), and MAX()
- GROUP BY and HAVING
- CASE WHEN conditional logic
- Subqueries
- Common Table Expressions (CTEs)
- Window functions: DENSE_RANK(), LEAD(), and SUM() OVER()
- Revenue calculations and percentage contribution analysis

## Key Areas of Analysis
1. **Data Validation:** Review records, date ranges, distinct orders, and missing values.
2. **Overall Performance:** Calculate revenue, order volume, and average order value.
3. **Product Performance:** Compare pizza products by revenue and quantity sold.
4. **Category and Size Analysis:** Examine sales contribution by category and pizza size.
5. **Order Timing:** Explore hourly order counts and revenue.
6. **Advanced Analysis:** Use conditional logic, subqueries, CTEs, and window functions to answer business questions.

## Repository Contents
- `Pizza_Sales_SQL_Analysis.sql` — SQL queries organized by analytical topic.

## How to Use This Project
1. Download the SQL file from this repository.
2. Import the pizza sales dataset into a MySQL database.
3. Update the database and table references in the SQL file if necessary.
4. Open the file in DBeaver or another MySQL-compatible SQL editor.
5. Execute the queries individually and review the results.

## Notes
The analysis depends on the structure and contents of the supplied dataset. Results should be validated against the imported data before drawing business conclusions.

## Author
Data Analytics Portfolio Project
Greeshma K G
