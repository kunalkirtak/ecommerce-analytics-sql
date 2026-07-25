-- =======================================================
-- ECOMMERCE ANALYTICS SQL PORTFOLIO
-- File: materialized_views.sql
-- Purpose: Demonstrates materialized views for
--          analytics queries that are expensive to
--          recompute on every request (e.g. dashboards).
-- Database: PostgreSQL
-- =======================================================

-------------------------------------------------------
-- Materialized View: mv_monthly_revenue
-------------------------------------------------------
-- Total revenue and order count per calendar month.
-- Cancelled orders are excluded from revenue.
DROP MATERIALIZED VIEW IF EXISTS mv_monthly_revenue;

CREATE MATERIALIZED VIEW mv_monthly_revenue AS
SELECT
    DATE_TRUNC('month', o.order_date)::DATE AS revenue_month,
    COUNT(DISTINCT o.order_id)                AS total_orders,
    SUM(o.total_amount)                         AS total_revenue,
    ROUND(AVG(o.total_amount), 2)                 AS avg_order_value
FROM orders o
WHERE o.status <> 'Cancelled'
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY revenue_month;

-- A unique index on the grouping column enables
-- REFRESH MATERIALIZED VIEW CONCURRENTLY (non-blocking
-- refresh) in production-like usage.
CREATE UNIQUE INDEX IF NOT EXISTS idx_mv_monthly_revenue_month
    ON mv_monthly_revenue (revenue_month);

COMMENT ON MATERIALIZED VIEW mv_monthly_revenue IS 'Precomputed monthly revenue, order count, and AOV.';

-------------------------------------------------------
-- Materialized View: mv_top_selling_products
-------------------------------------------------------
-- Ranks products by total revenue generated, useful for
-- a "best sellers" dashboard panel that doesn't need to
-- recompute on every page load.
DROP MATERIALIZED VIEW IF EXISTS mv_top_selling_products;

CREATE MATERIALIZED VIEW mv_top_selling_products AS
SELECT
    p.product_id,
    p.product_name,
    cat.category_name,
    SUM(oi.quantity)                            AS units_sold,
    SUM(oi.subtotal)                              AS total_revenue,
    RANK() OVER (ORDER BY SUM(oi.subtotal) DESC)   AS revenue_rank
FROM order_items oi
JOIN orders o        ON o.order_id = oi.order_id AND o.status <> 'Cancelled'
JOIN products p      ON p.product_id = oi.product_id
LEFT JOIN categories cat ON cat.category_id = p.category_id
GROUP BY p.product_id, p.product_name, cat.category_name
ORDER BY total_revenue DESC;

CREATE UNIQUE INDEX IF NOT EXISTS idx_mv_top_products_id
    ON mv_top_selling_products (product_id);

COMMENT ON MATERIALIZED VIEW mv_top_selling_products IS 'Products ranked by total revenue generated (excludes cancelled orders).';

-------------------------------------------------------
-- How to refresh (run after loading new data)
-------------------------------------------------------
-- REFRESH MATERIALIZED VIEW CONCURRENTLY mv_monthly_revenue;
-- REFRESH MATERIALIZED VIEW CONCURRENTLY mv_top_selling_products;

