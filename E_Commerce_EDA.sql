USE E_Commerce_db;
-- ============================================================
-- Data Profiling 
-- ============================================================
-- Row counts for every table
SELECT 'users' AS tbl, COUNT(*) AS total_rows FROM users
UNION ALL
SELECT 'products',   COUNT(*) FROM products
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'orders',     COUNT(*) FROM orders
UNION ALL
SELECT 'order_items',COUNT(*) FROM order_items
UNION ALL
SELECT 'payments',   COUNT(*) FROM payments;

-- Date range of orders
SELECT
    MIN(order_date) AS earliest_order_date, 
	MAX(order_date) AS latest_order_date,
    COUNT(*) AS total_orders
FROM orders;

-- Price range of products
SELECT 
	MAX(price) AS highest_price,
    MIN(price) AS lowest_price,
    ROUND(AVG(price),2) AS avg_price,
    COUNT(*) AS total_products
FROM products;

-- ============================================================
-- NULL Value Check
-- ============================================================
-- Check for NULLs in users
SELECT
	COUNT(*) - COUNT(name) AS null_name,
    COUNT(*) - COUNT(email) AS null_email,
    COUNT(*) - COUNT(phone) AS null_phone,
    COUNT(*) - COUNT(address) AS null_address
FROM users;

-- Check for NULLs in orders
SELECT
	COUNT(*) - COUNT(user_id) AS null_user_id,
    COUNT(*) - COUNT(total_amount) AS null_total_amount,
    COUNT(*) - COUNT(status) AS null_status,
    COUNT(*) - COUNT(order_date) AS null_order_date
FROM orders;

-- ============================================================
-- Distribution Analysis
-- ============================================================
-- Orders by status distribution
SELECT 
	status, 
    COUNT(*) AS count,
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS percentage
FROM orders
GROUP BY status
ORDER BY count DESC;

-- Orders per month
SELECT 	
	DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(user_id) AS total_order,
    SUM(total_amount) AS total_revenue
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- Product price distribution by category
SELECT 
	c.name AS category_name,
    COUNT(p.id) AS total_products,
    SUM(p.price) AS total_price_by_category,
    MAX(p.price) AS max_price_by_category,
    MIN(p.price) AS min_price_by_category,
    ROUND(AVG(p.price), 2) AS avg_price_by_category
FROM categories c
JOIN products p
ON c.id = p.category_id
GROUP BY c.name;

-- ============================================================
-- Outlier Detection
-- ============================================================
-- Orders with unusually high amounts (above 2x average)
SELECT 
	id AS order_id,
    user_id,
	total_amount,
    DATE(order_date)
FROM orders
WHERE total_amount> 2 * (SELECT AVG(total_amount) FROM orders)
ORDER BY total_amount DESC;

-- Products with zero stock
SELECT 
	p.id AS product_id,
    p.name AS product_name,
    c.name AS category,
    SUM(p.stock_qty) AS stock_amount,
	SUM(p.price) AS product_price
FROM products p
JOIN categories c
ON p.category_id = c.id
GROUP BY p.id, p.name
HAVING stock_amount = 0;

-- Users with unusually high number of revenue
SELECT 
	user_id,
    user_name,
    user_email,
    total_orders,
	total_sold_price,
	CASE
		WHEN total_sold_price >= 30000 THEN 'HIGH'
		WHEN total_sold_price BETWEEN 10000 AND 30000 THEN 'MEDIUM'
		ELSE 'LOW'
	END AS user_rank
FROM(
SELECT 
	u.id AS user_id,
    u.name AS user_name,
    u.email AS user_email,
    COUNT(o.user_id) AS total_orders,
	SUM(o.total_amount) AS total_sold_price
FROM orders o
JOIN users u
ON o.user_id = u.id
GROUP BY u.id
ORDER BY total_orders)t
ORDER BY user_rank;

-- ============================================================
-- User Behaviour Analysis
-- ============================================================
-- Average orders per user
SELECT 
	ROUND(AVG(order_count),2) AS avg_orders_per_user
FROM (SELECT user_id, COUNT(*) AS order_count FROM orders GROUP BY user_id) sub;

-- Users who have placed most order
SELECT 
	u.id,
    u.name,
    u.email,
    COUNT(o.user_id) AS total_orders,
    SUM(o.total_amount) AS total_price
FROM orders o
JOIN users u
ON o.user_id = u.id
GROUP BY u.id
ORDER BY total_orders;

-- Top 5 most active buyers
SELECT 
	u.id,
    u.name,
    u.email,
    COUNT(o.user_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM orders o
JOIN users u
ON o.user_id = u.id
GROUP BY u.id
ORDER BY total_spent DESC
LIMIT 5;