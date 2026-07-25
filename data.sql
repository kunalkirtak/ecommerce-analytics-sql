-- =======================================================
-- ECOMMERCE ANALYTICS SQL PORTFOLIO
-- File: data.sql
-- Purpose: Populates all tables with realistic sample data.
-- Database: PostgreSQL
-- =======================================================

-------------------------------------------------------
-- Insert Categories
-------------------------------------------------------
INSERT INTO categories (category_name, description) VALUES
('Electronics',        'Phones, laptops, audio equipment, and accessories'),
('Home & Kitchen',     'Appliances, cookware, and household essentials'),
('Fashion',            'Clothing, footwear, and accessories'),
('Books',               'Fiction, non-fiction, and academic titles'),
('Sports & Outdoors',  'Fitness gear, camping, and outdoor equipment'),
('Beauty & Personal Care', 'Skincare, haircare, and grooming products'),
('Toys & Games',       'Kids toys, board games, and puzzles');

-------------------------------------------------------
-- Insert Customers
-------------------------------------------------------
INSERT INTO customers (first_name, last_name, email, phone, city, state, country, signup_date) VALUES
('Ava',      'Thompson',   'ava.thompson@email.com',   '555-0110', 'Austin',       'Texas',         'USA',        '2023-01-15'),
('Liam',     'Carter',     'liam.carter@email.com',    '555-0111', 'Denver',       'Colorado',      'USA',        '2023-02-02'),
('Riya',     'Sharma',     'riya.sharma@email.com',    '91-98765-11223', 'Pune',   'Maharashtra',   'India',      '2023-02-20'),
('Noah',     'Bennett',    'noah.bennett@email.com',   '555-0112', 'Seattle',      'Washington',    'USA',        '2023-03-05'),
('Emma',     'Wilson',     'emma.wilson@email.com',    '44-7700-900123', 'London', 'Greater London','UK',         '2023-03-18'),
('Arjun',    'Verma',      'arjun.verma@email.com',    '91-98765-33445', 'Mumbai', 'Maharashtra',   'India',      '2023-04-01'),
('Sophia',   'Martinez',   'sophia.martinez@email.com','555-0113', 'Miami',        'Florida',       'USA',        '2023-04-22'),
('Ethan',    'Walker',     'ethan.walker@email.com',   '555-0114', 'Chicago',      'Illinois',      'USA',        '2023-05-09'),
('Isabella', 'Rossi',      'isabella.rossi@email.com', '39-333-1234567', 'Milan',  'Lombardy',      'Italy',      '2023-05-30'),
('Mason',    'Clarke',     'mason.clarke@email.com',   '555-0115', 'Portland',     'Oregon',        'USA',        '2023-06-14'),
('Priya',    'Nair',       'priya.nair@email.com',     '91-98765-55667', 'Bengaluru','Karnataka',   'India',      '2023-07-01'),
('Lucas',    'Anderson',   'lucas.anderson@email.com', '555-0116', 'Boston',       'Massachusetts', 'USA',        '2023-07-19'),
('Mia',      'Johansson',  'mia.johansson@email.com',  '46-70-1234567', 'Stockholm','Stockholm County','Sweden', '2023-08-03'),
('Aditya',   'Rao',        'aditya.rao@email.com',     '91-98765-77889', 'Hyderabad','Telangana',   'India',      '2023-08-21'),
('Charlotte','Dubois',     'charlotte.dubois@email.com','33-6-12345678','Lyon',    'Auvergne-Rhone-Alpes','France','2023-09-10'),
('James',    'Murphy',     'james.murphy@email.com',   '555-0117', 'Phoenix',      'Arizona',       'USA',        '2023-09-27'),
('Ananya',   'Iyer',       'ananya.iyer@email.com',    '91-98765-99001', 'Chennai','Tamil Nadu',    'India',      '2023-10-12'),
('Benjamin', 'Foster',     'benjamin.foster@email.com','555-0118', 'Nashville',    'Tennessee',     'USA',        '2023-11-02'),
('Olivia',   'Bergstrom',  'olivia.bergstrom@email.com','47-98-765432','Oslo',     'Oslo',          'Norway',     '2023-11-25'),
('Rohan',    'Kapoor',     'rohan.kapoor@email.com',   '91-98765-22110', 'Delhi',  'Delhi',         'India',      '2023-12-08');

-------------------------------------------------------
-- Insert Products
-------------------------------------------------------
-- category_id references:
-- 1 = Electronics, 2 = Home & Kitchen, 3 = Fashion,
-- 4 = Books, 5 = Sports & Outdoors,
-- 6 = Beauty & Personal Care, 7 = Toys & Games
INSERT INTO products (product_name, category_id, price, stock_quantity, created_at) VALUES
('Wireless Bluetooth Earbuds',        1, 49.99,  150, '2023-01-05'),
('27-inch 4K Monitor',                 1, 329.99,  40, '2023-01-10'),
('Smartphone Fast Charger 65W',        1, 24.99,  200, '2023-01-12'),
('Mechanical Keyboard - RGB',          1, 79.99,   85, '2023-01-20'),
('Portable Bluetooth Speaker',         1, 59.99,  120, '2023-02-01'),
('Stainless Steel Cookware Set',       2, 129.99,  60, '2023-02-05'),
('Electric Kettle 1.7L',               2, 34.99,  100, '2023-02-10'),
('Non-Stick Frying Pan',               2, 22.50,  140, '2023-02-15'),
('Robot Vacuum Cleaner',               2, 249.99,  30, '2023-02-25'),
('Ceramic Dinnerware Set (16-piece)',  2, 89.99,   45, '2023-03-01'),
('Men''s Slim Fit Cotton Shirt',       3, 29.99,  180, '2023-03-05'),
('Women''s Running Shoes',             3, 74.99,  110, '2023-03-10'),
('Denim Jacket - Unisex',              3, 59.99,   95, '2023-03-15'),
('Leather Wallet',                     3, 34.99,  130, '2023-03-20'),
('Winter Wool Scarf',                  3, 19.99,  160, '2023-03-25'),
('Atomic Habits (Paperback)',          4, 16.99,  200, '2023-04-01'),
('The Pragmatic Programmer',           4, 39.99,   75, '2023-04-05'),
('SQL for Data Analysis (Guide)',      4, 27.99,   90, '2023-04-10'),
('World Atlas - Illustrated Edition',  4, 45.00,   50, '2023-04-15'),
('Yoga Mat - Extra Thick',             5, 21.99,  170, '2023-05-01'),
('Adjustable Dumbbell Set',            5, 149.99,  40, '2023-05-05'),
('Camping Tent (4-Person)',            5, 189.99,  25, '2023-05-10'),
('Resistance Bands Set',               5, 15.99,  220, '2023-05-15'),
('Insulated Water Bottle 1L',          5, 18.99,  240, '2023-05-20'),
('Vitamin C Facial Serum',             6, 24.99,  150, '2023-06-01'),
('Organic Shampoo & Conditioner Set',  6, 27.99,  130, '2023-06-05'),
('Electric Hair Trimmer',              6, 32.99,   80, '2023-06-10'),
('Wooden Building Blocks Set',         7, 29.99,  100, '2023-06-15'),
('Strategy Board Game - Family Edition',7, 34.99,  70, '2023-06-20'),
('Remote Control Car',                 7, 44.99,   65, '2023-06-25');

-- =======================================================
-- SECTION 2: TRANSACTIONAL DATA
-- =======================================================

-------------------------------------------------------
-- Insert Orders
-------------------------------------------------------
INSERT INTO orders (order_id, customer_id, order_date, status, total_amount) VALUES
(1, 2, '2024-01-10', 'Processing', 127.96),
(2, 8, '2024-01-28', 'Delivered', 219.96),
(3, 7, '2024-01-27', 'Pending', 644.92),
(4, 6, '2024-01-21', 'Pending', 46.98),
(5, 20, '2024-01-09', 'Shipped', 219.98),
(6, 3, '2024-01-13', 'Delivered', 269.92),
(7, 7, '2024-02-16', 'Pending', 294.95),
(8, 19, '2024-02-09', 'Processing', 409.94),
(9, 13, '2024-02-05', 'Delivered', 625.95),
(10, 12, '2024-02-13', 'Shipped', 903.92),
(11, 17, '2024-02-25', 'Delivered', 294.96),
(12, 17, '2024-02-25', 'Processing', 174.96),
(13, 13, '2024-03-12', 'Delivered', 108.96),
(14, 11, '2024-03-16', 'Delivered', 159.98),
(15, 1, '2024-03-02', 'Delivered', 79.99),
(16, 16, '2024-03-25', 'Delivered', 689.95),
(17, 5, '2024-03-17', 'Delivered', 342.90),
(18, 4, '2024-03-22', 'Shipped', 114.96),
(19, 19, '2024-04-11', 'Delivered', 135.00),
(20, 7, '2024-04-08', 'Processing', 74.97),
(21, 10, '2024-04-02', 'Delivered', 214.95),
(22, 5, '2024-04-05', 'Processing', 172.45),
(23, 1, '2024-04-14', 'Shipped', 666.92),
(24, 6, '2024-04-11', 'Cancelled', 22.50),
(25, 14, '2024-05-14', 'Delivered', 269.98);

-- Keep the sequence in sync since we inserted explicit IDs
SELECT setval('orders_order_id_seq', (SELECT MAX(order_id) FROM orders));

-------------------------------------------------------
-- Insert Order Items
-------------------------------------------------------
-- Note: 'subtotal' is a generated column and must NOT be listed here.
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1, 19, 1, 45.00),
(2, 1, 7, 1, 34.99),
(3, 1, 23, 3, 15.99),
(4, 2, 28, 2, 29.99),
(5, 2, 4, 2, 79.99),
(6, 3, 6, 3, 129.99),
(7, 3, 12, 2, 74.99),
(8, 3, 7, 3, 34.99),
(9, 4, 18, 1, 27.99),
(10, 4, 24, 1, 18.99),
(11, 5, 22, 1, 189.99),
(12, 5, 11, 1, 29.99),
(13, 6, 3, 3, 24.99),
(14, 6, 7, 3, 34.99),
(15, 6, 30, 2, 44.99),
(16, 7, 29, 1, 34.99),
(17, 7, 30, 2, 44.99),
(18, 7, 21, 1, 149.99),
(19, 7, 15, 1, 19.99),
(20, 8, 29, 1, 34.99),
(21, 8, 19, 1, 45.00),
(22, 8, 13, 3, 59.99),
(23, 8, 12, 2, 74.99),
(24, 9, 26, 2, 27.99),
(25, 9, 22, 3, 189.99),
(26, 10, 17, 1, 39.99),
(27, 10, 9, 3, 249.99),
(28, 10, 18, 3, 27.99),
(29, 10, 28, 1, 29.99),
(30, 11, 4, 1, 79.99),
(31, 11, 10, 2, 89.99),
(32, 11, 14, 1, 34.99),
(33, 12, 17, 1, 39.99),
(34, 12, 30, 3, 44.99),
(35, 13, 18, 3, 27.99),
(36, 13, 25, 1, 24.99),
(37, 14, 4, 2, 79.99),
(38, 15, 29, 1, 34.99),
(39, 15, 19, 1, 45.00),
(40, 16, 5, 2, 59.99),
(41, 16, 22, 3, 189.99),
(42, 17, 7, 3, 34.99),
(43, 17, 30, 3, 44.99),
(44, 17, 18, 1, 27.99),
(45, 17, 25, 3, 24.99),
(46, 18, 15, 2, 19.99),
(47, 18, 29, 1, 34.99),
(48, 18, 17, 1, 39.99),
(49, 19, 19, 3, 45.00),
(50, 20, 3, 3, 24.99),
(51, 21, 3, 2, 24.99),
(52, 21, 17, 3, 39.99),
(53, 21, 8, 2, 22.50),
(54, 22, 8, 1, 22.50),
(55, 22, 26, 1, 27.99),
(56, 22, 16, 1, 16.99),
(57, 22, 14, 3, 34.99),
(58, 23, 28, 3, 29.99),
(59, 23, 24, 3, 18.99),
(60, 23, 2, 1, 329.99),
(61, 23, 22, 1, 189.99),
(62, 24, 8, 1, 22.50),
(63, 25, 9, 1, 249.99),
(64, 25, 15, 1, 19.99);

SELECT setval('order_items_order_item_id_seq', (SELECT MAX(order_item_id) FROM order_items));

-------------------------------------------------------
-- Insert Payments
-------------------------------------------------------
INSERT INTO payments (order_id, payment_date, payment_method, amount, status) VALUES
(1, '2024-01-10', 'Debit Card', 0.00, 'Pending'),
(2, '2024-01-28', 'Net Banking', 219.96, 'Completed'),
(3, '2024-01-27', 'Credit Card', 0.00, 'Pending'),
(4, '2024-01-21', 'Net Banking', 0.00, 'Pending'),
(5, '2024-01-09', 'Credit Card', 219.98, 'Completed'),
(6, '2024-01-13', 'Debit Card', 269.92, 'Completed'),
(7, '2024-02-16', 'Cash on Delivery', 0.00, 'Pending'),
(8, '2024-02-09', 'Credit Card', 409.94, 'Completed'),
(9, '2024-02-05', 'Credit Card', 625.95, 'Completed'),
(10, '2024-02-13', 'Cash on Delivery', 903.92, 'Completed'),
(11, '2024-02-25', 'UPI', 294.96, 'Completed'),
(12, '2024-02-25', 'UPI', 174.96, 'Completed'),
(13, '2024-03-12', 'Cash on Delivery', 108.96, 'Completed'),
(14, '2024-03-16', 'UPI', 159.98, 'Completed'),
(15, '2024-03-02', 'Net Banking', 79.99, 'Completed'),
(16, '2024-03-25', 'Debit Card', 689.95, 'Completed'),
(17, '2024-03-17', 'UPI', 342.90, 'Completed'),
(18, '2024-03-22', 'Debit Card', 114.96, 'Completed'),
(19, '2024-04-11', 'Debit Card', 135.00, 'Completed'),
(20, '2024-04-08', 'Credit Card', 74.97, 'Completed'),
(21, '2024-04-02', 'Debit Card', 214.95, 'Completed'),
(22, '2024-04-05', 'Net Banking', 0.00, 'Pending'),
(23, '2024-04-14', 'Net Banking', 666.92, 'Completed'),
(24, '2024-04-11', 'Debit Card', 0.00, 'Failed'),
(25, '2024-05-14', 'Net Banking', 269.98, 'Completed');

-------------------------------------------------------
-- Insert Reviews
-------------------------------------------------------
INSERT INTO reviews (review_id, product_id, customer_id, rating, review_text, review_date) VALUES
(1, 28, 8, 4, 'Exceeded my expectations, highly recommend.', '2024-01-28'),
(2, 3, 3, 4, 'Solid build quality and easy to use.', '2024-01-19'),
(3, 26, 13, 5, 'Solid build quality and easy to use.', '2024-03-12'),
(4, 10, 17, 5, 'Really happy with this purchase, would buy again.', '2024-02-25'),
(5, 14, 17, 4, 'Exceeded my expectations, highly recommend.', '2024-02-28'),
(6, 18, 13, 4, 'Exceeded my expectations, highly recommend.', '2024-03-12'),
(7, 4, 11, 5, 'Exactly what I expected, great quality for the price.', '2024-03-22'),
(8, 29, 1, 4, 'Exactly what I expected, great quality for the price.', '2024-03-08'),
(9, 22, 16, 4, 'Really happy with this purchase, would buy again.', '2024-03-28'),
(10, 5, 16, 5, 'Really happy with this purchase, would buy again.', '2024-04-28'),
(11, 7, 5, 4, 'Exceeded my expectations, highly recommend.', '2024-03-18'),
(12, 19, 19, 5, 'Really happy with this purchase, would buy again.', '2024-04-14'),
(13, 17, 10, 4, 'Exceeded my expectations, highly recommend.', '2024-05-11'),
(14, 3, 10, 1, 'Disappointed with this one, wouldn''t repurchase.', '2024-04-12'),
(15, 9, 14, 5, 'Exactly what I expected, great quality for the price.', '2024-05-18'),
(16, 15, 14, 5, 'Works perfectly and arrived earlier than expected.', '2024-06-17');

SELECT setval('reviews_review_id_seq', (SELECT MAX(review_id) FROM reviews));

