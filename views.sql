-- =======================================================
-- ECOMMERCE ANALYTICS SQL PORTFOLIO
-- File: views.sql
-- Purpose: Reusable views that simplify common reporting
--          questions so they don't need to be rewritten
--          as raw joins every time.
-- Database: PostgreSQL
-- =======================================================

-------------------------------------------------------
-- View: vw_order_summary
-------------------------------------------------------
-- One row per order with the customer's name, how many
-- line items it contains, and its current status.
-- Useful as the base for most order-level reporting.
DROP VIEW IF EXISTS vw_order_summary;

CREATE VIEW vw_order_summary AS
SELECT
    o.order_id,
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    o.order_date,
    o.status,
    COUNT(oi.order_item_id)  AS item_count,
    SUM(oi.quantity)          AS total_units,
    o.total_amount
FROM orders o
JOIN customers c        ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, c.customer_id, c.first_name, c.last_name, o.order_date, o.status, o.total_amount;

COMMENT ON VIEW vw_order_summary IS 'Order-level summary: customer, item count, units, and total amount.';

-------------------------------------------------------
-- View: vw_product_performance
-------------------------------------------------------
-- Per-product sales and review performance. Only counts
-- items from orders that were not cancelled, so revenue
-- reflects sales that actually went through.
DROP VIEW IF EXISTS vw_product_performance;

CREATE VIEW vw_product_performance AS
SELECT
    p.product_id,
    p.product_name,
    cat.category_name,
    p.price,
    COALESCE(SUM(oi.quantity), 0)                       AS units_sold,
    COALESCE(SUM(oi.subtotal), 0)                        AS revenue,
    ROUND(AVG(r.rating), 2)                                AS avg_rating,
    COUNT(DISTINCT r.review_id)                             AS review_count
FROM products p
LEFT JOIN categories cat   ON cat.category_id = p.category_id
LEFT JOIN order_items oi   ON oi.product_id = p.product_id
LEFT JOIN orders o         ON o.order_id = oi.order_id AND o.status <> 'Cancelled'
LEFT JOIN reviews r        ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name, cat.category_name, p.price;

COMMENT ON VIEW vw_product_performance IS 'Per-product units sold, revenue (excluding cancelled orders), and review stats.';

-------------------------------------------------------
-- View: vw_customer_lifetime_value
-------------------------------------------------------
-- Per-customer order count, total spend, and average
-- order value. Customers with zero orders still appear,
-- with zeroed-out metrics (LEFT JOIN).
DROP VIEW IF EXISTS vw_customer_lifetime_value;

CREATE VIEW vw_customer_lifetime_value AS
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.country,
    COUNT(o.order_id)                                    AS total_orders,
    COALESCE(SUM(o.total_amount), 0)                        AS lifetime_spend,
    ROUND(COALESCE(AVG(o.total_amount), 0), 2)                AS avg_order_value,
    MAX(o.order_date)                                          AS last_order_date
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id AND o.status <> 'Cancelled'
GROUP BY c.customer_id, c.first_name, c.last_name, c.country;

COMMENT ON VIEW vw_customer_lifetime_value IS 'Per-customer lifetime spend and order behavior, excluding cancelled orders.';

