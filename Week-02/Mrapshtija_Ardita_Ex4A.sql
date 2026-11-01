DROP DATABASE IF EXISTS beanbrew_ops;
CREATE DATABASE beanbrew_ops;
USE beanbrew_ops;
SET SQL_SAFE_UPDATES = 1;

CREATE TABLE category
( category_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
category_name VARCHAR(30) NOT NULL
);
CREATE TABLE product
( product_id INT PRIMARY KEY AUTO_INCREMENT,
product_name VARCHAR(100) NOT NULL,
category_id TINYINT UNSIGNED NOT NULL,
unit_price DECIMAL(6,2) NOT NULL,
stock_qty INT UNSIGNED,
active BOOLEAN NOT NULL DEFAULT TRUE,
CONSTRAINT chk_price_positive CHECK (unit_price > 0),
CONSTRAINT fk_product_category FOREIGN KEY (category_id)
REFERENCES category(category_id)
ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE customer
( customer_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
email VARCHAR(100),
city VARCHAR(40),
loyalty_points INT UNSIGNED NOT NULL DEFAULT 0,
joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT uq_customer_email UNIQUE (email)
);
CREATE TABLE orders
( order_id INT PRIMARY KEY AUTO_INCREMENT,
customer_id INT NOT NULL,
product_id INT NOT NULL,
order_date DATE NOT NULL,
quantity SMALLINT UNSIGNED NOT NULL DEFAULT 1,
CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
REFERENCES customer(customer_id)
ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk_orders_product FOREIGN KEY (product_id)
REFERENCES product(product_id)
ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO category (category_name) VALUES
('Coffee'), ('Tea'), ('Bakery'), ('Merchandise');
INSERT INTO product (product_name, category_id, unit_price, stock_qty) VALUES
('House Blend Drip', 1, 2.75, 120), ('Espresso Single', 1, 3.25, 80),
('Caramel Latte', 1, 4.95, 60), ('Cold Brew', 1, 4.50, 45),
('Earl Grey', 2, 2.95, 50), ('Chai Latte', 2, 4.75, 40),
('Blueberry Muffin', 3, 3.50, 24), ('Butter Croissant', 3, 3.25, 30),
('Cinnamon Roll', 3, 3.95, 18), ('Logo Travel Mug', 4, 14.99, 25),
('Pumpkin Spice Latte', 1, 5.45, 35), ('Ceramic Pour-Over Set', 4, 29.99, NULL);
INSERT INTO customer (first_name, last_name, email, city, loyalty_points) VALUES
('Maria', 'Lopez', 'maria.lopez@example.com', 'Boston', 340),
('James', 'Carter', 'james.carter@example.com', 'Cambridge', 120),
('Aisha', 'Khan', 'aisha.khan@example.com', 'Boston', 560),
('Tom', 'Nguyen', NULL, 'Somerville', 75),
('Priya', 'Shah', 'priya.shah@example.com', 'Boston', 0),
('Daniel', 'Brooks', 'daniel.brooks@example.com', 'Quincy', 210);
INSERT INTO orders (customer_id, product_id, order_date, quantity) VALUES
(1, 3, '2026-09-01', 1), (2, 1, '2026-09-02', 2), (3, 7, '2026-09-03', 1),
(1, 5, '2026-09-03', 1), (3, 11, '2026-09-04', 2), (4, 2, '2026-09-05', 1),
(6, 10, '2026-09-06', 1), (1, 11, '2026-09-08', 1), (2, 8, '2026-09-09', 3);
-- Check the row counts
SELECT 'category' AS table_name, COUNT(*) AS row_count FROM category
UNION ALL SELECT 'product', COUNT(*) FROM product
UNION ALL SELECT 'customer', COUNT(*) FROM customer
UNION ALL SELECT 'orders', COUNT(*) FROM orders;

-- Task 1.1: See everything in a table
SELECT * FROM category;
SELECT * FROM product;

-- Task 1.2: Choose the columns you need
SELECT first_name, last_name, city
FROM customer;

-- Task 1.3: Return the result of an expression
-- (a) Expressions without a table
SELECT 85 + 33;
SELECT 'Do not delete';
-- (b) A calculated column
SELECT product_name, unit_price, stock_qty,
unit_price * stock_qty AS stock_value
FROM product;

-- Task 2.1: Match a value exactly
SELECT first_name, last_name, city
FROM customer
WHERE city = 'Boston';
SELECT first_name, last_name, city
FROM customer
WHERE city <> 'Boston';

-- Task 2.2: Compare numbers
SELECT product_name, unit_price
FROM product
WHERE unit_price < 4.00;
SELECT first_name, loyalty_points
FROM customer
WHERE loyalty_points >= 200;

-- Task 2.3: Search for a pattern
SELECT product_id, product_name
FROM product
WHERE product_name LIKE '%Latte%';
SELECT first_name, last_name
FROM customer
WHERE last_name LIKE 'K%';

-- Task 2.4: Combine conditions
SELECT product_name, category_id, unit_price
FROM product
WHERE category_id = 1 AND unit_price < 4.00;
SELECT first_name, city
FROM customer
WHERE city = 'Cambridge' OR city = 'Somerville';

-- Task 2.5: Predict, then run: looking for missing values
SELECT first_name, last_name, email
FROM customer
WHERE email = NULL; -- no records returned 

SELECT first_name, last_name, email
FROM customer
WHERE email IS NULL; -- Tom Nguyen has a Null email value 

-- Task 3.1: Add a product (INSERT with a column list)
INSERT INTO product (product_name, category_id, unit_price, stock_qty)
VALUES ('Oat Milk Flat White', 1, 5.25, 30);
SELECT LAST_INSERT_ID(); -- 13
SELECT * FROM product
WHERE product_id = 13; -- Oat Milk Flat White

-- Task 3.2: Predict, then run: INSERT without a column list
INSERT INTO category
VALUES (5, 'Seasonal');

INSERT INTO category
VALUES ('Gift Cards'); -- Error Code: 1136. Column count doesn't match value count at row 1
SELECT * FROM category; -- Coffee, Tea, Bakery, Merchandise, Seasonal

-- Task 3.3: Add several customers at once
INSERT INTO customer (first_name, last_name, email, city) VALUES
('Olivia', 'Grant', 'olivia.grant@example.com', 'Boston'),
('Ravi', 'Patel', NULL, 'Cambridge'),
('Grace', 'Kim', 'grace.kim@example.com', NULL);
SELECT customer_id, first_name, last_name, email, city, loyalty_points
FROM customer
WHERE customer_id >= 7; -- Olivia Grant, Ravi Patel, Grace Kim

-- Task 3.4: Predict, then run: leave out a required column
INSERT INTO customer (first_name, email)
VALUES ('Leo', 'leo.martin@example.com'); -- Error Code: 1364. Field 'last_name' doesn't have a default value
SELECT COUNT(*) FROM customer; -- 9 customers

-- Task 3.5: Record a sale
INSERT INTO orders (customer_id, product_id, order_date)
VALUES (7, 13, '2026-10-01');
INSERT INTO orders (customer_id, product_id, order_date)
VALUES (99, 1, '2026-10-01'); -- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`beanbrew_ops`.`orders`, CONSTRAINT `fk_orders_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE RESTRICT ON UPDATE CASCADE
SELECT * FROM orders
WHERE order_date >= '2026-10-01'; -- Order_id =10, customer_id =7

-- Task 4.1: Change one value
SELECT product_id, product_name, unit_price
FROM product
WHERE product_id = 4; -- ColdBrew price 4.50
UPDATE product
SET unit_price = 4.75
WHERE product_id = 4;
SELECT product_id, product_name, unit_price
FROM product
WHERE product_id = 4;

-- Task 4.2: Change several columns at once
UPDATE customer
SET email = 'ravi.patel@example.com',
city = 'Somerville'
WHERE customer_id = 8;
SELECT customer_id, first_name, email, city
FROM customer
WHERE customer_id = 8; 

-- Task 4.3: Calculate the new value
UPDATE customer
SET loyalty_points = loyalty_points + 25
WHERE customer_id = 1;
SELECT customer_id, first_name, loyalty_points
FROM customer
WHERE customer_id = 1; -- Maria now has 365 points

-- Task 4.4: Predict, then run: safe update mode
UPDATE customer
SET loyalty_points = loyalty_points + 50
WHERE city = 'Boston'; -- Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.
SELECT customer_id, first_name, city, loyalty_points
FROM customer
WHERE city = 'Boston'; -- Maria, Aisha, Priya, Olivia
SET SQL_SAFE_UPDATES = 0;
UPDATE customer
SET loyalty_points = loyalty_points + 50
WHERE city = 'Boston';
SET SQL_SAFE_UPDATES = 1;
SELECT customer_id, first_name, city, loyalty_points
FROM customer
WHERE city = 'Boston'; -- All 4 customers have an extra 50 loyalty points

-- Task 5.1: Delete one record
SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id = 9; -- Grace Kim
DELETE FROM customer
WHERE customer_id = 9;
SELECT COUNT(*) FROM customer; -- 8 customers

-- Task 5.2: Predict, then run: delete a record with history
DELETE FROM product
WHERE product_id = 11; -- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`beanbrew_ops`.`orders`, CONSTRAINT `fk_orders_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`) ON DELETE RESTRICT ON UPDATE CASCADE)
SELECT COUNT(*) FROM product; -- 13 products 

-- Task 5.3: Retire a product instead (soft delete)
UPDATE product
SET active = FALSE
WHERE product_id = 11;

SELECT product_id, product_name, active
FROM product
WHERE active = FALSE; -- Pumpkin Spice Late
SELECT COUNT(*) AS menu_items
FROM product
WHERE active = TRUE;
SELECT order_id, customer_id, product_id, order_date
FROM orders
WHERE product_id = 11;

-- Task 5.4: Predict, then run: the forgotten WHERE
CREATE TEMPORARY TABLE customer_copy AS
SELECT customer_id, first_name, city FROM customer;
UPDATE customer_copy SET city = 'Quincy'; -- Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.
SET SQL_SAFE_UPDATES = 0;
UPDATE customer_copy SET city = 'Quincy';
SELECT * FROM customer_copy; -- 8 customers returned
DELETE FROM customer_copy;
SET SQL_SAFE_UPDATES = 1;
SELECT COUNT(*) FROM customer_copy; -- 0
DROP TEMPORARY TABLE customer_copy;
SELECT COUNT(*) FROM customer; -- 8 count

-- Task 6.1: Raise a whole category's prices
SELECT product_id, product_name, unit_price
FROM product
WHERE category_id = 3; -- Original unit price: 3.50, 3.25, 3.95
UPDATE product
SET unit_price = unit_price + 0.25
WHERE category_id = 3;
SELECT product_id, product_name, unit_price
FROM product
WHERE category_id = 3; -- Updated prices: 3.75, 3.50, 4.20

-- Task 6.2: New customer, first order
INSERT INTO customer (first_name, last_name, email, city)
VALUES ('Noah', 'Bennett', 'noah.bennett@example.com', 'Quincy');
SELECT LAST_INSERT_ID();
INSERT INTO orders (customer_id, product_id, order_date, quantity)
VALUES (LAST_INSERT_ID(), 6, '2026-10-02', 2);
SELECT order_id, customer_id, product_id, order_date, quantity
FROM orders
WHERE customer_id = 10;

-- self-check the row counts
SELECT 'category' AS table_name, COUNT(*) AS row_count FROM category
UNION ALL SELECT 'product', COUNT(*) FROM product
UNION ALL SELECT 'customer', COUNT(*) FROM customer
UNION ALL SELECT 'orders', COUNT(*) FROM orders;

SELECT COUNT(*) FROM product WHERE active = TRUE; -- 12 menu items
SELECT
@@SQL_SAFE_UPDATES; -- 1, safety is on