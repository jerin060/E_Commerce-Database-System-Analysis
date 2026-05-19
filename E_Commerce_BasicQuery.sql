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

-- ============================================================
-- Create a view for order summary
-- ============================================================
CREATE OR REPLACE VIEW vw_order_summary AS
SELECT 
    o.id AS order_ID,
    DATE(o.order_date) AS order_date,
    u.name AS customer_name,
    p.name AS product_name,
    oi.quantity,
    o.status AS order_status,
    oi.unit_price AS total_bill,
    DATE(pm.payment_date) AS payment_date,
    pm.method AS pay_method,
    pm.status AS pay_status
FROM users u
JOIN orders o
ON u.id = o.user_id
JOIN order_items oi
ON o.id = oi.order_id
JOIN products p
ON oi.product_id = p.id
JOIN payments pm
ON o.id = pm.order_id
ORDER BY o.order_date;

SELECT *
FROM vw_order_summary;

-- ============================================================
-- BONUS: Auto-deduct stock after order item insert
-- ============================================================
DELIMITER $$

CREATE TRIGGER trg_reduce_stock
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock_qty = stock_qty - NEW.quantity
    WHERE id = NEW.product_id;
END $$

DELIMITER ;

-- ============================================================
-- BONUS: Trigger — Auto-update order total when item is added
-- ============================================================
DELIMITER $$

CREATE TRIGGER trg_update_order_total
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders
    SET total_amount = (
        SELECT SUM(quantity * unit_price)
        FROM order_items
        WHERE order_id = NEW.order_id
    )
    WHERE id = NEW.order_id;
END $$

DELIMITER ;