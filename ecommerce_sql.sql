CREATE DATABASE ecommerce_analysis;
USE ecommerce_analysis;
SELECT DATABASE();
SHOW TABLES;

SELECT COUNT(*) AS total_records
FROM sales;
SELECT *
FROM sales
LIMIT 10;

-- 1. TOTAL REVENUE
SELECT
    ROUND(SUM(quantity * price), 2) AS total_revenue
FROM sales;

-- 2. MONTHLY REVENUE
SELECT
    DATE_FORMAT(invoicedate, '%Y-%m') AS sales_month,
    ROUND(SUM(quantity * price), 2) AS monthly_revenue
FROM sales
GROUP BY sales_month
ORDER BY sales_month;

-- 3. TOP 10 PRODUCTS BY REVENUE
SELECT
    description,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * price), 2) AS revenue
FROM sales
GROUP BY description
ORDER BY revenue DESC
LIMIT 10;

-- 4. TOP CUSTOMERS BY SPENDING
SELECT
    country,
    ROUND(SUM(quantity * price), 2) AS revenue
FROM sales
GROUP BY country
ORDER BY revenue DESC
LIMIT 10;


SELECT
    customer_id,
    COUNT(DISTINCT invoice) AS total_orders,
    ROUND(SUM(quantity * price), 2) AS total_spent
FROM sales
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- 5. REPEAT CUSTOMER ANALYSIS
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice) AS total_orders
    FROM sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN total_orders = 1 THEN 1 ELSE 0 END)
        AS one_time_customers,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)
        AS repeat_customers
FROM customer_orders;

WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(quantity * price) AS revenue
    FROM sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT
    customer_id,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        100 * revenue / SUM(revenue) OVER (),
        2
    ) AS revenue_percentage
FROM customer_revenue
ORDER BY revenue DESC
LIMIT 10;

