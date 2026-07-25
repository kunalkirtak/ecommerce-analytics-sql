# 📊 Customer Analytics Dashboard (PostgreSQL)

A PostgreSQL portfolio project demonstrating customer analytics using modern SQL techniques.

## Objectives

Build an analytics database capable of answering business questions such as:

- Who are the highest-value customers?
- Which cities generate the highest revenue?
- Which product categories perform best?
- What are monthly sales trends?
- Which customers purchase most frequently?

---

## SQL Skills Demonstrated

- CREATE TABLE
- INSERT INTO
- GROUP BY
- Aggregate Functions
- Views
- Common Table Expressions (CTEs)
- Window Functions
- Indexes

---

## Database Design

The project contains four related tables.

- customers
- products
- orders
- order_items

---

## Folder Structure

```text
schema.sql
```

Creates database tables.

```text
data.sql
```

Loads sample data.

```text
analytics_queries.sql
```

Business analytics queries.

```text
views.sql
```

Reusable reporting views.

```text
indexes.sql
```

Performance optimization.

---

## Technologies

- PostgreSQL
- SQL

---

## Learning Outcomes

This project demonstrates practical SQL used in customer analytics, reporting, business intelligence, and AI/ML data preparation.

---

## How to Run

Create a database.

```sql
CREATE DATABASE customer_analytics;
```

Connect to it.

Execute the files in this order:

1. schema.sql
2. data.sql
3. views.sql
4. indexes.sql
5. analytics_queries.sql

---

## License

MIT
