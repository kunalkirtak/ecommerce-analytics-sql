# 🛒 E-Commerce Analytics SQL Portfolio

A PostgreSQL portfolio project that models a simplified e-commerce platform — customers, product catalog, orders, payments, and reviews — and uses it to demonstrate practical SQL and database design skills, from schema design through analytics queries.

> **Status:** Part 1 of 3 (Database design, schema, and initial data). Transactional data, views, indexes, and analytics queries are added in later parts.

---

## 📖 Project Overview

This project simulates the backend database of a small online store. It's built to show the kind of SQL work a Data Analyst, Data Engineer, or backend-adjacent AI/ML Engineer does day to day: designing a normalized schema, loading realistic data, and writing queries that answer real business questions (top customers, revenue by category, repeat purchase rate, etc.).

The project is intentionally scoped like a strong student/portfolio project — realistic and well-documented, but not artificially over-engineered.

---

## 🧠 SQL Topics Covered

- Relational database design & normalization
- DDL: `CREATE TABLE`, data types, constraints
- Primary keys, foreign keys, `ON DELETE` behavior
- `CHECK` constraints and generated columns
- DML: bulk `INSERT` with realistic sample data
- Joins (`INNER JOIN`, `LEFT JOIN`)
- Aggregate functions & `GROUP BY` / `HAVING`
- Subqueries and Common Table Expressions (CTEs)
- Window functions (`RANK`, `ROW_NUMBER`, running totals)
- Views and materialized views
- Indexing for query performance
- Business/analytics-style reporting queries

---

## 🗄️ Database Overview

The database models **7 core entities**:

| Table | Purpose |
|---|---|
| `customers` | Registered users who place orders |
| `categories` | Product category taxonomy |
| `products` | Catalog items available for sale |
| `orders` | Order headers (one row per order) |
| `order_items` | Line items within an order (order detail) |
| `payments` | Payment transactions tied to an order |
| `reviews` | Customer ratings and feedback on products |

### Entity-Relationship Diagram

```mermaid
erDiagram
    CUSTOMERS ||--o{ ORDERS : places
    CUSTOMERS ||--o{ REVIEWS : writes
    CATEGORIES ||--o{ PRODUCTS : contains
    PRODUCTS ||--o{ ORDER_ITEMS : "ordered in"
    PRODUCTS ||--o{ REVIEWS : receives
    ORDERS ||--o{ ORDER_ITEMS : contains
    ORDERS ||--o{ PAYMENTS : "paid by"

    CUSTOMERS {
        int customer_id PK
        varchar first_name
        varchar last_name
        varchar email
        varchar phone
        varchar city
        varchar state
        varchar country
        date signup_date
    }
    CATEGORIES {
        int category_id PK
        varchar category_name
        text description
    }
    PRODUCTS {
        int product_id PK
        varchar product_name
        int category_id FK
        numeric price
        int stock_quantity
        date created_at
    }
    ORDERS {
        int order_id PK
        int customer_id FK
        date order_date
        varchar status
        numeric total_amount
    }
    ORDER_ITEMS {
        int order_item_id PK
        int order_id FK
        int product_id FK
        int quantity
        numeric unit_price
        numeric subtotal
    }
    PAYMENTS {
        int payment_id PK
        int order_id FK
        date payment_date
        varchar payment_method
        numeric amount
        varchar status
    }
    REVIEWS {
        int review_id PK
        int product_id FK
        int customer_id FK
        int rating
        text review_text
        date review_date
    }
```

---

## 📋 Table Descriptions

**`customers`** — Customer accounts: name, contact info, location, and signup date. `email` is unique.

**`categories`** — High-level product groupings (Electronics, Fashion, Books, etc.). Referenced by `products`.

**`products`** — Catalog items with price and stock. `category_id` is a foreign key to `categories`; set to `NULL` if a category is removed.

**`orders`** — One row per order placed by a customer. Tracks order status (`Pending` → `Delivered`/`Cancelled`) and a running `total_amount`.

**`order_items`** — Line items for each order (which products, how many, at what price). `subtotal` is a **generated column** (`quantity * unit_price`), computed automatically by PostgreSQL.

**`payments`** — Payment attempts linked to an order, including method (Credit Card, UPI, etc.) and status.

**`reviews`** — Star ratings (1–5) and optional written feedback, linked to both a product and the customer who wrote it.

---

## 📁 Folder Structure

```
ecommerce-analytics-sql/
├── README.md               -- This file
├── schema.sql               -- Table definitions, constraints, PK/FK
├── data.sql                  -- Sample data (customers, categories, products)
├── queries.sql               -- Analysis & business queries (Part 2)
├── views.sql                  -- Reusable views (Part 2)
├── indexes.sql                 -- Performance indexes (Part 2)
├── materialized_views.sql       -- Materialized views (Part 2)
├── screenshots/                  -- Query result screenshots for the README
├── LICENSE
└── .gitignore
```

---

## 🛠️ Technologies Used

- **PostgreSQL** (14+) — database engine
- **psql** / **pgAdmin** — execution and inspection
- **Mermaid** — ER diagram (rendered natively by GitHub)
- **Markdown** — documentation

---

## 🧩 Database Schema Summary

- 7 tables, fully normalized (3NF)
- Every table has a `SERIAL PRIMARY KEY`
- 6 foreign key relationships enforcing referential integrity
- `CHECK` constraints on price, quantity, rating, and enum-style status columns
- One generated column (`order_items.subtotal`) to demonstrate computed columns
- Designed to support realistic analytics: revenue by category, top customers, order status breakdowns, review sentiment by rating, etc.

---

## ▶️ How to Run This Project

### 1. Create the database
```bash
psql -U postgres -c "CREATE DATABASE ecommerce_db;"
```

### 2. Connect to it
```bash
psql -U postgres -d ecommerce_db
```

### 3. Run the schema file
```bash
\i schema.sql
```
*(or from the terminal: `psql -U postgres -d ecommerce_db -f schema.sql`)*

### 4. Load the sample data
```bash
\i data.sql
```

### 5. (Later parts) Run the remaining files in order
```bash
\i views.sql
\i indexes.sql
\i materialized_views.sql
```

### 6. Verify the tables loaded correctly
```sql
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
```

### 7. Run example/business queries
```bash
\i queries.sql
```

**Using pgAdmin instead of psql?** Open the Query Tool, connect to `ecommerce_db`, then open and execute each `.sql` file in the order above (Schema → Data → Views → Indexes → Queries).

---

## 🔍 Example Queries

A few examples of the kind of SQL this project supports (full set in `queries.sql`, added in Part 2):

```sql
-- All products in the Electronics category, cheapest first
SELECT product_name, price, stock_quantity
FROM products
WHERE category_id = (SELECT category_id FROM categories WHERE category_name = 'Electronics')
ORDER BY price ASC;

-- Customers who have not placed any orders yet
SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;
```

---

## 🎓 Learning Outcomes

By building and studying this project, you practice:

- Translating a real-world scenario into a normalized relational schema
- Choosing appropriate data types and constraints to protect data integrity
- Writing multi-table joins to answer business questions
- Structuring a SQL codebase the way it would appear in a real engineering repo
- Communicating a technical project clearly through documentation

---

## 💡 Skills Demonstrated

`PostgreSQL` `Database Design` `Normalization` `DDL/DML` `Joins` `Aggregation` `Constraints` `Views` `Indexing` `SQL Documentation`

---

## 🚀 Future Improvements

- Add a `shipping_addresses` table to support multiple addresses per customer
- Add a `discounts` / `coupons` table and apply it in order totals
- Partition `orders` by year for large-scale simulation
- Add role-based access control (read-only analyst role vs. admin role)
- Build a small dashboard (e.g., Metabase or a BI tool) on top of the views

---

## 📄 License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.
