USE E_Commerce_db;
-- ============================================================
-- Basic Queries
-- ============================================================
-- Find all users whose name starts with 'A'
SELECT *
FROM users
WHERE name LIKE 'A%';

-- Get products under a specific category
SELECT * 
FROM products p
LEFT JOIN categories c
ON p.category_id = c.id
WHERE c.name = 'Electronics';

-- Find orders within a date range
SELECT 
	u.id AS user_id,
    u.name,
    o.total_amount,
    o.status,
    o.order_date
FROM orders o
LEFT JOIN users u
ON o.user_ID = u.id
WHERE o.order_date BETWEEN '2024-02-01' AND '2024-04-30';

-- ============================================================
-- Aggregation
-- ============================================================
-- Total sales per user
SELECT 
    u.id AS customer_ID,
    u.name AS customer_name,
    COUNT(o.id) AS total_orders,
    SUM(o.total_amount) AS total_sale
FROM orders o 
JOIN users u
ON u.id = o.user_id
GROUP BY u.id, u.name
ORDER BY total_sale DESC;

-- Total orders per day
SELECT 
	DATE(o.order_date)AS order_date,
    u.id AS customer_ID,
    u.name AS customer_name,
    COUNT(o.id) AS total_orders,
    SUM(o.total_amount) AS total_sale
FROM orders o 
JOIN users u
ON u.id = o.user_id
GROUP BY o.id, o.order_date
ORDER BY o.order_date;

-- Users who spent more than 5000
SELECT 
    u.id AS customer_ID,
    u.name AS customer_name,
    SUM(o.total_amount) AS total_sale,
    o.status
FROM orders o 
JOIN users u
ON u.id = o.user_id
WHERE o.status = 'delivered'
GROUP BY o.id, o.order_date
HAVING SUM(o.total_amount) > 5000
ORDER BY o.order_date;