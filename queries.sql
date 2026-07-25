-- =======================================================
-- ECOMMERCE ANALYTICS SQL PORTFOLIO
-- File: queries.sql
-- Purpose: Business/analytics queries that answer real
--          questions using this schema. Organized by
--          SQL technique so it doubles as a study guide.
-- Database: PostgreSQL
-- =======================================================
-- Run this file AFTER schema.sql, data.sql, and views.sql.
-- =======================================================


-- =======================================================
-- SECTION 1: BASIC FILTERING & SORTING
-- =======================================================

-------------------------------------------------------
-- 1.1 All products in the Electronics category, cheapest first
-------------------------------------------------------
SELECT product_name, price, stock_quantity
FROM products
WHERE category_id = (SELECT category_id FROM categories WHERE category_name = 'Electronics')
ORDER BY price ASC;

-------------------------------------------------------
-- 1.2 Products that are low on stock (fewer than 40 units)
-------------------------------------------------------
SELECT product_name, stock_quantity
FROM products
WHERE stock_quantity < 40
ORDER BY stock_quantity ASC;

-------------------------------------------------------
-- 1.3 Orders placed in the last 60 days (relative to the newest order)
-------------------------------------------------------
SELECT order_id, customer_id, order_date, status, total_amount
FROM orders
WHERE order_date >= (SELECT MAX(order_date) FROM orders) - INTERVAL '60 days'
ORDER BY order_date DESC;


-- =======================================================
-- SECTION 2: JOINS
-- =======================================================

-------------------------------------------------------
-- 2.1 Customers who have never placed an order (LEFT JOIN + NULL check)
-------------------------------------------------------
SELECT c.customer_id, c.first_name, c.last_name, c.email
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

-------------------------------------------------------
-- 2.2 Full order detail: customer + product + line item info
-------------------------------------------------------
SELECT
    o.order_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.subtotal,
    o.status
FROM orders o
JOIN customers c    ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p     ON p.product_id = oi.product_id
ORDER BY o.order_id;

-------------------------------------------------------
-- 2.3 Products that have never been ordered (LEFT JOIN + NULL check)
-------------------------------------------------------
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
WHERE oi.order_item_id IS NULL;


-- =======================================================
-- SECTION 3: AGGREGATION & GROUP BY
-- =======================================================

-------------------------------------------------------
-- 3.1 Revenue and order count per category (excludes cancelled orders)
-------------------------------------------------------
SELECT
    cat.category_name,
    COUNT(DISTINCT o.order_id)   AS orders_count,
    SUM(oi.subtotal)               AS category_revenue
FROM order_items oi
JOIN orders o    ON o.order_id = oi.order_id AND o.status <> 'Cancelled'
JOIN products p  ON p.product_id = oi.product_id
JOIN categories cat ON cat.category_id = p.category_id
GROUP BY cat.category_name
ORDER BY category_revenue DESC;

-------------------------------------------------------
-- 3.2 Average order value by country
-------------------------------------------------------
SELECT
    c.country,
    COUNT(o.order_id)               AS total_orders,
    ROUND(AVG(o.total_amount), 2)     AS avg_order_value
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.status <> 'Cancelled'
GROUP BY c.country
ORDER BY avg_order_value DESC;

-------------------------------------------------------
-- 3.3 Order status breakdown (funnel view)
-------------------------------------------------------
SELECT
    status,
    COUNT(*)                                              AS order_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM orders), 1) AS pct_of_all_orders
FROM orders
GROUP BY status
ORDER BY order_count DESC;

-------------------------------------------------------
-- 3.4 Categories with more than 3 distinct orders (HAVING)
-------------------------------------------------------
SELECT
    cat.category_name,
    COUNT(DISTINCT o.order_id) AS orders_count
FROM order_items oi
JOIN orders o        ON o.order_id = oi.order_id
JOIN products p      ON p.product_id = oi.product_id
JOIN categories cat  ON cat.category_id = p.category_id
GROUP BY cat.category_name
HAVING COUNT(DISTINCT o.order_id) > 3
ORDER BY orders_count DESC;


-- =======================================================
-- SECTION 4: SUBQUERIES & CTEs
-- =======================================================

-------------------------------------------------------
-- 4.1 Customers who spent more than the average customer (subquery)
-------------------------------------------------------
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.status <> 'Cancelled'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(o.total_amount) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(total_amount) AS customer_total
        FROM orders
        WHERE status <> 'Cancelled'
        GROUP BY customer_id
    ) AS per_customer_totals
)
ORDER BY total_spent DESC;

-------------------------------------------------------
-- 4.2 Top 5 customers by lifetime spend (CTE)
-------------------------------------------------------
WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        SUM(o.total_amount) AS lifetime_spend
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    WHERE o.status <> 'Cancelled'
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT *
FROM customer_totals
ORDER BY lifetime_spend DESC
LIMIT 5;

-------------------------------------------------------
-- 4.3 Best-rated products with at least 2 reviews (CTE)
-------------------------------------------------------
WITH product_ratings AS (
    SELECT
        p.product_id,
        p.product_name,
        COUNT(r.review_id)      AS review_count,
        ROUND(AVG(r.rating), 2)   AS avg_rating
    FROM products p
    JOIN reviews r ON r.product_id = p.product_id
    GROUP BY p.product_id, p.product_name
)
SELECT *
FROM product_ratings
WHERE review_count >= 2
ORDER BY avg_rating DESC, review_count DESC;


-- =======================================================
-- SECTION 5: WINDOW FUNCTIONS
-- =======================================================

-------------------------------------------------------
-- 5.1 Rank products within their category by revenue
-------------------------------------------------------
SELECT
    cat.category_name,
    p.product_name,
    SUM(oi.subtotal) AS product_revenue,
    RANK() OVER (PARTITION BY cat.category_name ORDER BY SUM(oi.subtotal) DESC) AS rank_in_category
FROM order_items oi
JOIN orders o        ON o.order_id = oi.order_id AND o.status <> 'Cancelled'
JOIN products p      ON p.product_id = oi.product_id
JOIN categories cat  ON cat.category_id = p.category_id
GROUP BY cat.category_name, p.product_name
ORDER BY cat.category_name, rank_in_category;

-------------------------------------------------------
-- 5.2 Running total of revenue by order date
-------------------------------------------------------
SELECT
    order_date,
    order_id,
    total_amount,
    SUM(total_amount) OVER (ORDER BY order_date, order_id) AS running_revenue
FROM orders
WHERE status <> 'Cancelled'
ORDER BY order_date, order_id;

-------------------------------------------------------
-- 5.3 Each customer's orders numbered chronologically
--      (identifies 1st order, 2nd order, etc. per customer)
-------------------------------------------------------
SELECT
    customer_id,
    order_id,
    order_date,
    total_amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_sequence
FROM orders
WHERE status <> 'Cancelled'
ORDER BY customer_id, order_sequence;

-------------------------------------------------------
-- 5.4 Month-over-month revenue change
-------------------------------------------------------
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', order_date)::DATE AS revenue_month,
        SUM(total_amount) AS revenue
    FROM orders
    WHERE status <> 'Cancelled'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    revenue_month,
    revenue,
    LAG(revenue) OVER (ORDER BY revenue_month) AS prev_month_revenue,
    ROUND(
        100.0 * (revenue - LAG(revenue) OVER (ORDER BY revenue_month))
        / LAG(revenue) OVER (ORDER BY revenue_month), 1
    ) AS pct_change
FROM monthly
ORDER BY revenue_month;


-- =======================================================
-- SECTION 6: USING THE VIEWS (views.sql)
-- =======================================================

-------------------------------------------------------
-- 6.1 Customer lifetime value leaderboard
-------------------------------------------------------
SELECT customer_name, country, total_orders, lifetime_spend, avg_order_value
FROM vw_customer_lifetime_value
ORDER BY lifetime_spend DESC
LIMIT 10;

-------------------------------------------------------
-- 6.2 Product performance: revenue vs. rating
-------------------------------------------------------
SELECT product_name, category_name, units_sold, revenue, avg_rating, review_count
FROM vw_product_performance
WHERE units_sold > 0
ORDER BY revenue DESC;

-- =======================================================
-- SECTION 7: ADVANCED ANALYTICS
-- =======================================================

-------------------------------------------------------
-- 7.1 RFM-style customer segmentation
-------------------------------------------------------
-- Recency (days since last order), Frequency (order count),
-- and Monetary (total spend) are the classic three inputs
-- to a customer segmentation model.
WITH customer_rfm AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        MAX(o.order_date) AS last_order_date,
        (SELECT MAX(order_date) FROM orders WHERE status <> 'Cancelled') - MAX(o.order_date) AS recency_days,
        COUNT(o.order_id) AS frequency,
        SUM(o.total_amount) AS monetary
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id AND o.status <> 'Cancelled'
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT
    customer_name,
    recency_days,
    frequency,
    monetary,
    CASE
        WHEN recency_days <= 30 AND frequency >= 2 THEN 'Champion'
        WHEN recency_days <= 60 THEN 'Active'
        WHEN recency_days <= 120 THEN 'At Risk'
        ELSE 'Churned'
    END AS segment
FROM customer_rfm
ORDER BY monetary DESC;

-------------------------------------------------------
-- 7.2 Market basket analysis: products frequently bought together
-------------------------------------------------------
-- Self-join on order_items (same order, different product) to
-- find product pairs that co-occur in multiple orders.
SELECT
    p1.product_name AS product_a,
    p2.product_name AS product_b,
    COUNT(DISTINCT oi1.order_id) AS times_bought_together
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
JOIN products p1 ON p1.product_id = oi1.product_id
JOIN products p2 ON p2.product_id = oi2.product_id
GROUP BY p1.product_name, p2.product_name
HAVING COUNT(DISTINCT oi1.order_id) >= 2
ORDER BY times_bought_together DESC;

-------------------------------------------------------
-- 7.3 Revenue contribution % per category (window function over an aggregate)
-------------------------------------------------------
SELECT
    cat.category_name,
    SUM(oi.subtotal) AS category_revenue,
    ROUND(100.0 * SUM(oi.subtotal) / SUM(SUM(oi.subtotal)) OVER (), 1) AS pct_of_total_revenue
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id AND o.status <> 'Cancelled'
JOIN products p ON p.product_id = oi.product_id
JOIN categories cat ON cat.category_id = p.category_id
GROUP BY cat.category_name
ORDER BY category_revenue DESC;

-------------------------------------------------------
-- 7.4 Monthly order volume with gap detection
-------------------------------------------------------
-- generate_series() fills in every calendar month in range,
-- even ones with zero orders, so gaps are visible instead of
-- silently missing from the result set.
WITH month_range AS (
    SELECT generate_series(
        (SELECT MIN(DATE_TRUNC('month', order_date)) FROM orders),
        (SELECT MAX(DATE_TRUNC('month', order_date)) FROM orders),
        INTERVAL '1 month'
    )::DATE AS month
),
monthly_orders AS (
    SELECT DATE_TRUNC('month', order_date)::DATE AS month, COUNT(*) AS orders_count
    FROM orders
    WHERE status <> 'Cancelled'
    GROUP BY 1
)
SELECT mr.month, COALESCE(mo.orders_count, 0) AS orders_count
FROM month_range mr
LEFT JOIN monthly_orders mo ON mo.month = mr.month
ORDER BY mr.month;

-------------------------------------------------------
-- 7.5 Longest gap (in days) between consecutive orders, per customer
-------------------------------------------------------
-- Classic "gaps and islands" pattern using LAG() to compare
-- each order's date to the customer's previous order date.
WITH customer_orders AS (
    SELECT
        customer_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date
    FROM orders
    WHERE status <> 'Cancelled'
)
SELECT
    customer_id,
    MAX(order_date - prev_order_date) AS longest_gap_days
FROM customer_orders
WHERE prev_order_date IS NOT NULL
GROUP BY customer_id
ORDER BY longest_gap_days DESC;

-------------------------------------------------------
-- 7.6 Median and 90th percentile order value
-------------------------------------------------------
-- PERCENTILE_CONT is more robust to outliers than AVG alone;
-- useful for understanding the "typical" vs. "high-end" order.
SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_amount) AS median_order_value,
    PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY total_amount) AS p90_order_value
FROM orders
WHERE status <> 'Cancelled';


-- =======================================================
-- SECTION 8: INTERVIEW-STYLE SQL QUESTIONS
-- =======================================================
-- Each question is phrased the way it might appear in a
-- SQL interview, followed by a solution using this schema.

-------------------------------------------------------
-- 8.1 "Find the second-highest priced product in each category."
-------------------------------------------------------
-- DENSE_RANK (not ROW_NUMBER) is used so tied prices don't
-- cause the "second place" to be skipped incorrectly.
WITH ranked_products AS (
    SELECT
        p.product_name,
        cat.category_name,
        p.price,
        DENSE_RANK() OVER (PARTITION BY cat.category_name ORDER BY p.price DESC) AS price_rank
    FROM products p
    JOIN categories cat ON cat.category_id = p.category_id
)
SELECT category_name, product_name, price
FROM ranked_products
WHERE price_rank = 2
ORDER BY category_name;

-------------------------------------------------------
-- 8.2 "Find the 3rd highest-spending customer."
-------------------------------------------------------
-- OFFSET/FETCH is the standard-SQL way to skip N rows;
-- built on top of the vw_customer_lifetime_value view.
SELECT customer_id, customer_name, lifetime_spend
FROM vw_customer_lifetime_value
ORDER BY lifetime_spend DESC
OFFSET 2 FETCH FIRST 1 ROW ONLY;

-------------------------------------------------------
-- 8.3 "Check the customers table for duplicate email addresses."
-------------------------------------------------------
-- Returns 0 rows here because `email` has a UNIQUE constraint
-- in schema.sql, but this is the standard pattern for finding
-- duplicates on any column that ISN'T protected by a constraint.
SELECT email, COUNT(*) AS occurrences
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;

-------------------------------------------------------
-- 8.4 "Find customers who have purchased from every single category."
-------------------------------------------------------
-- Classic relational-division problem: a customer "qualifies"
-- only if their count of distinct categories purchased equals
-- the total number of categories that exist.
-- Returns 0 rows on this sample dataset (no one has ordered
-- from all 7 categories yet) -- included to show the pattern.
WITH customer_categories AS (
    SELECT DISTINCT o.customer_id, p.category_id
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
    WHERE o.status <> 'Cancelled'
)
SELECT customer_id, COUNT(DISTINCT category_id) AS categories_covered
FROM customer_categories
GROUP BY customer_id
HAVING COUNT(DISTINCT category_id) = (SELECT COUNT(*) FROM categories);

-------------------------------------------------------
-- 8.5 "Pivot monthly revenue so each category is its own column."
-------------------------------------------------------
-- PostgreSQL has no native PIVOT keyword; conditional
-- aggregation with CASE WHEN is the standard workaround.
SELECT
    DATE_TRUNC('month', o.order_date)::DATE AS month,
    SUM(CASE WHEN cat.category_name = 'Electronics' THEN oi.subtotal ELSE 0 END) AS electronics,
    SUM(CASE WHEN cat.category_name = 'Fashion' THEN oi.subtotal ELSE 0 END) AS fashion,
    SUM(CASE WHEN cat.category_name = 'Home & Kitchen' THEN oi.subtotal ELSE 0 END) AS home_kitchen,
    SUM(CASE WHEN cat.category_name = 'Books' THEN oi.subtotal ELSE 0 END) AS books
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id AND o.status <> 'Cancelled'
JOIN products p ON p.product_id = oi.product_id
JOIN categories cat ON cat.category_id = p.category_id
GROUP BY month
ORDER BY month;

-------------------------------------------------------
-- 8.6 "For each customer, return only their most recent order."
-------------------------------------------------------
-- The classic "greatest-N-per-group" problem. DISTINCT ON is
-- a PostgreSQL-specific shortcut (not standard SQL, but very
-- idiomatic here) that keeps only the first row per group
-- after sorting.
SELECT DISTINCT ON (customer_id) customer_id, order_id, order_date, total_amount
FROM orders
ORDER BY customer_id, order_date DESC;

-------------------------------------------------------
-- 8.7 "Find products that sell well but have no reviews yet."
-------------------------------------------------------
-- Anti-join pattern (LEFT JOIN + IS NULL) combined with a
-- HAVING threshold -- useful for flagging products that need
-- review-generation campaigns.
SELECT p.product_id, p.product_name, SUM(oi.quantity) AS total_units_sold
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
LEFT JOIN reviews r ON r.product_id = p.product_id
WHERE r.review_id IS NULL
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) >= 3
ORDER BY total_units_sold DESC;

-- =======================================================
-- END OF QUERIES
-- =======================================================
