/*====================================================================
  PIZZA SALES SQL ANALYSIS
  Database : pizza_sales_db
  Table    : pizza_sales
  Tools    : MySQL / DBeaver

  Project purpose:
  Analyse sales performance, product contribution, ordering patterns,
  and category-level performance using practical SQL techniques.

  Dataset columns used:
  order_id, pizza_name_id, pizza_category, pizza_size, quantity,
  total_price, order_date, order_time, order_day
====================================================================*/

/*====================================================================
  SECTION 1 — DATA VALIDATION AND OVERVIEW
====================================================================*/

-- Q01. Confirm the active database.
SELECT DATABASE() AS active_database;

-- Q02. Preview a sample of the dataset.
SELECT *
FROM pizza_sales
LIMIT 20;

-- Q03. Count rows, unique orders, and distinct pizza types.
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT pizza_name_id) AS distinct_pizza_types
FROM pizza_sales;

-- Q04. Check the date range covered by the dataset.
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM pizza_sales;

-- Q05. Check missing values in key analysis columns.
SELECT
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(pizza_name_id IS NULL) AS missing_pizza_name_id,
    SUM(pizza_category IS NULL) AS missing_pizza_category,
    SUM(pizza_size IS NULL) AS missing_pizza_size,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(total_price IS NULL) AS missing_total_price,
    SUM(order_date IS NULL) AS missing_order_date,
    SUM(order_time IS NULL) AS missing_order_time
FROM pizza_sales;

/*====================================================================
  SECTION 2 — OVERALL BUSINESS PERFORMANCE
====================================================================*/

-- Q06. Calculate core sales KPIs.
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_pizzas_sold,
    ROUND(SUM(total_price), 2) AS total_revenue,
    ROUND(SUM(total_price) / NULLIF(COUNT(DISTINCT order_id), 0), 2)
        AS average_order_value
FROM pizza_sales;

-- Q07. Calculate revenue and quantity by pizza category.
SELECT
    pizza_category,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(total_price), 2) AS total_revenue
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_revenue DESC;

-- Q08. Calculate revenue contribution percentage by category.
WITH category_revenue AS (
    SELECT
        pizza_category,
        SUM(total_price) AS total_revenue
    FROM pizza_sales
    GROUP BY pizza_category
)
SELECT
    pizza_category,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(total_revenue / SUM(total_revenue) OVER () * 100, 2)
        AS revenue_percentage
FROM category_revenue
ORDER BY total_revenue DESC;

-- Q09. Compare quantity sold and revenue by pizza size.
SELECT
    pizza_size,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(total_price), 2) AS total_revenue
FROM pizza_sales
GROUP BY pizza_size
ORDER BY total_revenue DESC;

-- Q10. Compare revenue by pizza category and size.
SELECT
    pizza_category,
    pizza_size,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(total_price), 2) AS total_revenue
FROM pizza_sales
GROUP BY pizza_category, pizza_size
ORDER BY pizza_category, total_revenue DESC;

/*====================================================================
  SECTION 3 — PRODUCT PERFORMANCE
====================================================================*/

-- Q11. Find the five pizzas generating the most revenue.
SELECT
    pizza_name_id,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(total_price), 2) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name_id
ORDER BY total_revenue DESC
LIMIT 5;

-- Q12. Find the five pizzas generating the least revenue.
SELECT
    pizza_name_id,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(total_price), 2) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name_id
ORDER BY total_revenue ASC
LIMIT 5;

-- Q13. Find the five pizzas with the highest quantity sold.
SELECT
    pizza_name_id,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(total_price), 2) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name_id
ORDER BY total_quantity DESC
LIMIT 5;

-- Q14. Find the five pizzas with the lowest quantity sold.
SELECT
    pizza_name_id,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(total_price), 2) AS total_revenue
FROM pizza_sales
GROUP BY pizza_name_id
ORDER BY total_quantity ASC
LIMIT 5;

-- Q15. Compare revenue generated per pizza unit by pizza type.
SELECT
    pizza_name_id,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(total_price), 2) AS total_revenue,
    ROUND(SUM(total_price) / NULLIF(SUM(quantity), 0), 2)
        AS revenue_per_pizza_unit
FROM pizza_sales
GROUP BY pizza_name_id
ORDER BY revenue_per_pizza_unit DESC;

-- Q16. Find pizza types whose total revenue is above the average
--      total revenue per pizza type (subquery).
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
    ) AS pizza_revenue_summary
)
ORDER BY pizza_revenue DESC;

/*====================================================================
  SECTION 4 — ORDER AND TIME ANALYSIS
====================================================================*/

-- Q17. Count unique orders and pizza quantity by hour.
SELECT
    HOUR(order_time) AS order_hour,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity
FROM pizza_sales
GROUP BY HOUR(order_time)
ORDER BY order_hour;

-- Q18. Calculate revenue by hour.
SELECT
    HOUR(order_time) AS order_hour,
    ROUND(SUM(total_price), 2) AS total_revenue
FROM pizza_sales
GROUP BY HOUR(order_time)
ORDER BY total_revenue DESC;

-- Q19. Find orders containing more than one pizza unit.
SELECT
    order_id,
    SUM(quantity) AS total_pizza_units,
    ROUND(SUM(total_price), 2) AS order_revenue
FROM pizza_sales
GROUP BY order_id
HAVING SUM(quantity) > 1
ORDER BY total_pizza_units DESC, order_revenue DESC;

-- Q20. Calculate average order value by order hour.
--      First aggregate line items to one row per order, then average.
WITH order_totals AS (
    SELECT
        order_id,
        HOUR(MIN(order_time)) AS order_hour,
        SUM(total_price) AS order_revenue
    FROM pizza_sales
    GROUP BY order_id
)
SELECT
    order_hour,
    COUNT(*) AS total_orders,
    ROUND(AVG(order_revenue), 2) AS average_order_value
FROM order_totals
GROUP BY order_hour
ORDER BY order_hour;

/*====================================================================
  SECTION 5 — CONDITIONAL LOGIC AND AGGREGATION
====================================================================*/

-- Q21. Classify each sales row by quantity.
SELECT
    pizza_name_id,
    quantity,
    total_price,
    CASE
        WHEN quantity >= 3 THEN 'High Quantity'
        WHEN quantity = 2 THEN 'Medium Quantity'
        ELSE 'Low Quantity'
    END AS quantity_category
FROM pizza_sales;

-- Q22. Summarise quantity classifications by pizza category.
SELECT
    pizza_category,
    COUNT(*) AS sales_rows,
    SUM(CASE WHEN quantity >= 3 THEN 1 ELSE 0 END) AS high_quantity_rows,
    SUM(CASE WHEN quantity = 2 THEN 1 ELSE 0 END) AS medium_quantity_rows,
    SUM(CASE WHEN quantity = 1 THEN 1 ELSE 0 END) AS low_quantity_rows
FROM pizza_sales
GROUP BY pizza_category
ORDER BY pizza_category;

-- Q23. Find categories whose total revenue exceeds a chosen threshold.
--      Adjust 150000 to suit the dataset and analysis objective.
SELECT
    pizza_category,
    ROUND(SUM(total_price), 2) AS total_revenue
FROM pizza_sales
GROUP BY pizza_category
HAVING SUM(total_price) > 150000
ORDER BY total_revenue DESC;

/*====================================================================
  SECTION 6 — WINDOW FUNCTIONS AND ADVANCED ANALYSIS
====================================================================*/

-- Q24. Rank pizza types by revenue within each category.
WITH pizza_totals AS (
    SELECT
        pizza_name_id,
        pizza_category,
        SUM(quantity) AS total_quantity,
        SUM(total_price) AS pizza_revenue
    FROM pizza_sales
    GROUP BY pizza_name_id, pizza_category
)
SELECT
    pizza_name_id,
    pizza_category,
    total_quantity,
    ROUND(pizza_revenue, 2) AS pizza_revenue,
    DENSE_RANK() OVER (
        PARTITION BY pizza_category
        ORDER BY pizza_revenue DESC
    ) AS revenue_rank
FROM pizza_totals
ORDER BY pizza_category, revenue_rank, pizza_name_id;

-- Q25. Show the top three revenue ranks within each category.
--      Ties are retained, so a category may return more than three rows.
WITH pizza_totals AS (
    SELECT
        pizza_name_id,
        pizza_category,
        SUM(total_price) AS pizza_revenue
    FROM pizza_sales
    GROUP BY pizza_name_id, pizza_category
),
pizza_ranks AS (
    SELECT
        pizza_name_id,
        pizza_category,
        pizza_revenue,
        DENSE_RANK() OVER (
            PARTITION BY pizza_category
            ORDER BY pizza_revenue DESC
        ) AS revenue_rank
    FROM pizza_totals
)
SELECT
    pizza_name_id,
    pizza_category,
    ROUND(pizza_revenue, 2) AS pizza_revenue,
    revenue_rank
FROM pizza_ranks
WHERE revenue_rank <= 3
ORDER BY pizza_category, revenue_rank, pizza_name_id;

-- Q26. Calculate each pizza's percentage contribution to its category.
WITH pizza_totals AS (
    SELECT
        pizza_name_id,
        pizza_category,
        SUM(total_price) AS pizza_revenue
    FROM pizza_sales
    GROUP BY pizza_name_id, pizza_category
),
category_totals AS (
    SELECT
        pizza_category,
        SUM(total_price) AS category_revenue
    FROM pizza_sales
    GROUP BY pizza_category
)
SELECT
    p.pizza_name_id,
    p.pizza_category,
    ROUND(p.pizza_revenue, 2) AS pizza_revenue,
    ROUND(c.category_revenue, 2) AS category_revenue,
    ROUND(p.pizza_revenue / NULLIF(c.category_revenue, 0) * 100, 2)
        AS revenue_percentage
FROM pizza_totals AS p
JOIN category_totals AS c
    ON p.pizza_category = c.pizza_category
ORDER BY p.pizza_category, revenue_percentage DESC;

-- Q27. Compare each pizza's revenue with the next lower-ranked revenue
--      row in the overall list. Equal revenues can produce tied values.
WITH pizza_totals AS (
    SELECT
        pizza_name_id,
        SUM(total_price) AS pizza_revenue
    FROM pizza_sales
    GROUP BY pizza_name_id
),
revenue_comparison AS (
    SELECT
        pizza_name_id,
        pizza_revenue,
        LEAD(pizza_revenue) OVER (ORDER BY pizza_revenue DESC) AS next_pizza_revenue
    FROM pizza_totals
)
SELECT
    pizza_name_id,
    ROUND(pizza_revenue, 2) AS pizza_revenue,
    ROUND(next_pizza_revenue, 2) AS next_pizza_revenue,
    ROUND(pizza_revenue - next_pizza_revenue, 2) AS revenue_difference
FROM revenue_comparison
ORDER BY pizza_revenue DESC;

/*====================================================================
  SECTION 7 — FINAL BUSINESS SUMMARY
====================================================================*/

-- Q28. Produce a compact performance summary by pizza category.
SELECT
    pizza_category,
    COUNT(DISTINCT order_id) AS orders_containing_category,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(total_price), 2) AS total_revenue,
    ROUND(SUM(total_price) / NULLIF(SUM(quantity), 0), 2)
        AS revenue_per_pizza_unit
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_revenue DESC;

