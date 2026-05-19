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

