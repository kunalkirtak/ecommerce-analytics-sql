-- =======================================================
-- ECOMMERCE ANALYTICS SQL PORTFOLIO
-- File: schema.sql
-- Database: PostgreSQL
-- =======================================================

-- Drop tables if they already exist (safe re-run for local dev)
-- Order matters because of foreign key dependencies.
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

-------------------------------------------------------
-- Create Customers Table
-------------------------------------------------------
-- Stores customer account and contact information.
CREATE TABLE customers (
    customer_id     SERIAL PRIMARY KEY,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    email           VARCHAR(100) NOT NULL UNIQUE,
    phone           VARCHAR(20),
    city            VARCHAR(50),
    state           VARCHAR(50),
    country         VARCHAR(50),
    signup_date     DATE NOT NULL DEFAULT CURRENT_DATE
);

COMMENT ON TABLE customers IS 'Registered customers who place orders on the platform.';

-------------------------------------------------------
-- Create Categories Table
-------------------------------------------------------
-- Stores product categories (e.g., Electronics, Apparel).
CREATE TABLE categories (
    category_id     SERIAL PRIMARY KEY,
    category_name   VARCHAR(50) NOT NULL UNIQUE,
    description     TEXT
);

COMMENT ON TABLE categories IS 'High-level grouping used to organize products.';

-------------------------------------------------------
-- Create Products Table
-------------------------------------------------------
-- Stores catalog items available for purchase.
CREATE TABLE products (
    product_id      SERIAL PRIMARY KEY,
    product_name     VARCHAR(100) NOT NULL,
    category_id      INT REFERENCES categories(category_id) ON DELETE SET NULL,
    price            NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    stock_quantity   INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    created_at       DATE NOT NULL DEFAULT CURRENT_DATE
);

COMMENT ON TABLE products IS 'Catalog of items customers can purchase.';

-------------------------------------------------------
-- Create Orders Table
-------------------------------------------------------
-- Stores one row per customer order (header-level info).
CREATE TABLE orders (
    order_id         SERIAL PRIMARY KEY,
    customer_id      INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    order_date       DATE NOT NULL DEFAULT CURRENT_DATE,
    status           VARCHAR(20) NOT NULL DEFAULT 'Pending'
                        CHECK (status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')),
    total_amount     NUMERIC(10, 2) NOT NULL DEFAULT 0 CHECK (total_amount >= 0)
);

COMMENT ON TABLE orders IS 'Order header records; totals are derived from order_items.';

-------------------------------------------------------
-- Create Order_Items Table
-------------------------------------------------------
-- Stores individual line items within each order.
CREATE TABLE order_items (
    order_item_id    SERIAL PRIMARY KEY,
    order_id         INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id       INT NOT NULL REFERENCES products(product_id) ON DELETE RESTRICT,
    quantity         INT NOT NULL CHECK (quantity > 0),
    unit_price       NUMERIC(10, 2) NOT NULL CHECK (unit_price >= 0),
    -- subtotal is auto-calculated by PostgreSQL; demonstrates generated columns
    subtotal         NUMERIC(10, 2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);

COMMENT ON TABLE order_items IS 'Line items belonging to an order; subtotal is a generated column.';

-------------------------------------------------------
-- Create Payments Table
-------------------------------------------------------
-- Stores payment transactions tied to an order.
CREATE TABLE payments (
    payment_id       SERIAL PRIMARY KEY,
    order_id         INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    payment_date     DATE NOT NULL DEFAULT CURRENT_DATE,
    payment_method   VARCHAR(20) NOT NULL
                        CHECK (payment_method IN ('Credit Card', 'Debit Card', 'UPI', 'Net Banking', 'Cash on Delivery')),
    amount           NUMERIC(10, 2) NOT NULL CHECK (amount >= 0),
    status           VARCHAR(20) NOT NULL DEFAULT 'Completed'
                        CHECK (status IN ('Completed', 'Pending', 'Failed', 'Refunded'))
);

COMMENT ON TABLE payments IS 'Payment attempts/transactions associated with an order.';

-------------------------------------------------------
-- Create Reviews Table
-------------------------------------------------------
-- Stores customer reviews and ratings for products.
CREATE TABLE reviews (
    review_id        SERIAL PRIMARY KEY,
    product_id       INT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    customer_id      INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    rating           INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text      TEXT,
    review_date      DATE NOT NULL DEFAULT CURRENT_DATE
);

COMMENT ON TABLE reviews IS 'Customer-submitted ratings and written feedback on products.';

