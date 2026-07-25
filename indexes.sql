-- =======================================================
-- ECOMMERCE ANALYTICS SQL PORTFOLIO
-- File: indexes.sql
-- Purpose: Adds indexes that speed up the most common
--          access patterns in queries.sql and the views.
-- Database: PostgreSQL
-- =======================================================

-------------------------------------------------------
-- Foreign key lookups
-------------------------------------------------------
-- Postgres does NOT automatically index foreign key
-- columns (unlike the referenced primary key side), so
-- joins on these columns benefit from an explicit index.

CREATE INDEX IF NOT EXISTS idx_products_category_id
    ON products (category_id);

CREATE INDEX IF NOT EXISTS idx_orders_customer_id
    ON orders (customer_id);

CREATE INDEX IF NOT EXISTS idx_order_items_order_id
    ON order_items (order_id);

CREATE INDEX IF NOT EXISTS idx_order_items_product_id
    ON order_items (product_id);

CREATE INDEX IF NOT EXISTS idx_payments_order_id
    ON payments (order_id);

CREATE INDEX IF NOT EXISTS idx_reviews_product_id
    ON reviews (product_id);

CREATE INDEX IF NOT EXISTS idx_reviews_customer_id
    ON reviews (customer_id);

-------------------------------------------------------
-- Filtering & sorting columns
-------------------------------------------------------
-- These support common WHERE/ORDER BY patterns: filtering
-- orders by date range or status, and sorting products
-- by price.

CREATE INDEX IF NOT EXISTS idx_orders_order_date
    ON orders (order_date);

CREATE INDEX IF NOT EXISTS idx_orders_status
    ON orders (status);

CREATE INDEX IF NOT EXISTS idx_products_price
    ON products (price);

-------------------------------------------------------
-- Composite index example
-------------------------------------------------------
-- Speeds up the common "this customer's orders, most
-- recent first" access pattern in a single index instead
-- of two separate ones.
CREATE INDEX IF NOT EXISTS idx_orders_customer_date
    ON orders (customer_id, order_date DESC);
