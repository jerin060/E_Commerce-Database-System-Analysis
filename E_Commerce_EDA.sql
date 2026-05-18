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
FROM products
WHERE category_name = 'Electronics';

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

