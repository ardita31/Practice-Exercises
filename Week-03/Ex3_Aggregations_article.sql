-- Suppose you want to count how many films belong to a specific category 
-- (for example, the "Action" category), you can join the film and category tables.
SELECT COUNT(*) 
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';

-- For example, if you want to count the number of unique categories in the category table, you can use the following query.
SELECT COUNT(DISTINCT name) 
FROM category;

-- To sum the total amount of rentals from the rental table, you can use the following query.
SELECT SUM(amount) 
FROM payment;

-- To calculate the total payment amount per customer, you can use the following query.
SELECT customer_id, SUM(amount) 
FROM payment
GROUP BY customer_id;
-- This query groups the results by customer_id and returns the sum of payments for each customer.

-- To calculate both the average and total payment amounts, use the following query.
SELECT AVG(amount), SUM(amount) 
FROM payment;

-- To calculate the average film length from the film table in the sakila database, you can use the following query.
SELECT AVG(length) 
FROM film;

-- This query will return the average amount rounded to two decimal places
SELECT ROUND(AVG(amount), 2) 
FROM payment;

-- This query groups the results by customer_id and returns the average payment amount for each customer.
SELECT customer_id, AVG(amount) 
FROM payment
GROUP BY customer_id;

-- To find the earliest film release date from the film table, you can use MIN() with a release_year column.
SELECT MIN(release_year) 
FROM film;

-- This query returns the minimum rental rate for each film category.
SELECT c.name, fc.category_id, MIN(rental_rate)
FROM film f 
JOIN film_category fc
		ON f.film_id = fc.film_id
JOIN category c 
		ON fc.category_id = c.category_id
GROUP BY fc.category_id;

SELECT rental_rate 
FROM film
WHERE rental_rate < 0.99;

-- To find the highest payment amount in the payment table of the sakila database, use the following query.
SELECT MAX(amount) 
FROM payment;
-- This query will return the largest value from the amount column in the payment table, representing the highest payment made.

-- to find the highest payment amount per customer, you can use the following query.
SELECT customer_id, MAX(amount) 
FROM payment
GROUP BY customer_id;
-- This query returns the largest payment amount made by each customer.

-- To count how many rentals each customer has made, you can use the following query.
SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id;
-- This query groups the rows in the rental table by customer_id and returns the count of rentals for each customer.
-- The COUNT(*) function counts the number of rentals for each customer.

-- GROUP BY is executed after the FROM clause and any JOIN operations but before ORDER BY and LIMIT. 
-- This means grouping is done before sorting. If you want to sort the grouped data, you need to use ORDER BY after GROUP BY.
SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id
ORDER BY rental_count DESC;

-- You can group by more than one column to create subgroups. 
-- For example, grouping by both customer_id and film_id will return counts of rentals per customer per film.
SELECT r.customer_id, i.film_id, COUNT(*) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY r.customer_id, i.film_id;

-- If you want to find customers who have spent more than $100 on rentals, you can use SUM() in combination with HAVING.
SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
HAVING total_spent > 100;
-- This query groups the payments by customer_id and calculates the total amount spent by each customer. 
-- The HAVING clause filters out customers who have spent $100 or less, returning only those with a total expenditure greater than $100.

-- If you want to find customers who have rented more than 5 films, you can use COUNT() and filter the groups with HAVING.
SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id
HAVING rental_count > 5;
-- This query groups the data by customer_id and counts the number of rentals for each customer. 
-- The HAVING clause filters out customers who have rented 5 or fewer films, returning only those who have rented more than 5.


SELECT r.customer_id, COUNT(*) AS rental_count, SUM(p.amount) AS total_spent
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY r.customer_id
HAVING rental_count > 5 AND total_spent > 100;
-- This query will return the customers who have rented more than 5 films and spent more than $100 on rentals.

