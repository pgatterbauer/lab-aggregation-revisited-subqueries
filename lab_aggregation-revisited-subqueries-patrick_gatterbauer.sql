/** Instructions
Write the SQL queries to answer the following questions:
**/

## Select the first name, last name, and email address of all the customers who have rented a movie.

USE sakila;


SELECT
	c.first_name, c.last_name, c.email
FROM
	customer c
JOIN
	rental r
USING
	(customer_id)
GROUP BY
	c.first_name, c.last_name, c.email
HAVING
	COUNT(r.rental_id) > 0;

    
# What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

SELECT
	c.customer_id, CONCAT(c.first_name , ' ' , c.last_name) AS full_name, ROUND(AVG(p.amount), 2) as avg_payment
FROM
	customer c
JOIN
	payment p
USING
	(customer_id)
GROUP BY
	c.customer_id, full_name;
    
# Select the name and email address of all the customers who have rented the "Action" movies.
#Write the query using multiple join statements

SELECT
	CONCAT(c.first_name , ' ' , c.last_name) AS full_name, c.email
FROM
	customer c
JOIN
	rental r
USING
	(customer_id)
JOIN
	inventory
USING
	(inventory_id)
JOIN
	film_category fc
USING
	(film_id)
JOIN
	category cat
USING
	(category_id)
WHERE
	cat.name = "Action"
GROUP BY
	c.customer_id
ORDER BY
	full_name ASC;

#Write the query using sub queries with multiple WHERE clause and IN condition
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name, email
FROM
    (SELECT 
        first_name, last_name, email
    FROM
        customer
    WHERE
        customer_id IN (SELECT 
                customer_id
            FROM
                rental
            WHERE
                inventory_id IN (SELECT 
                        inventory_id
                    FROM
                        inventory
                    WHERE
                        film_id IN (SELECT 
                                film_id
                            FROM
                                film_category
                            WHERE
                                category_id IN (SELECT 
                                        category_id
                                    FROM
                                        category
                                    WHERE
                                        name = 'Action'))))) AS subs
ORDER BY 
	full_name ASC;

-- Verify if the above two queries produce the same results or not: Yes. Same results.


#Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
#If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, 
#the label should be medium, and if it is more than 4, then it should be high.
SELECT 
    r.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    p.amount,
    CASE
        WHEN p.amount < 2 THEN 'low'
        WHEN p.amount >= 2 AND p.amount <= 4 THEN 'medium'
        ELSE 'high'
    END AS payment_rating
FROM
    customer c
JOIN
    rental r 
USING 
	(customer_id)
JOIN
    payment p 
USING 
	(customer_id)
ORDER BY
	full_name ASC , p.amount ASC;

