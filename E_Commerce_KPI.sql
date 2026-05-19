USE E_Commerce_db;
-- ============================================================
-- Sales KPIs
-- ============================================================
-- Total Revenue (completed payments only)
SELECT 
	SUM(amount) AS total_revenue
FROM payments
WHERE status = 'completed';

-- Average Order Value (AOV)
SELECT 
	ROUND(AVG(total_amount),2) AS avg_order_value
FROM orders
WHERE status != "cancelled";

-- Revenue per Category
SELECT 
	c.name AS category_name,
    SUM(p.price) AS total_revenue
FROM products p
RIGHT JOIN categories c
ON p.category_id = c.id
GROUP BY c.id, c.name
ORDER BY total_revenue DESC;

-- Monthly Revenue Trend
SELECT 
	DATE_FORMAT(order_date, '%Y-%m') AS order_date,
    SUM(total_amount) AS total_revenue
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m');

-- ============================================================
-- Customer KPIs
-- ============================================================
-- Total active customer
SELECT 
	COUNT(DISTINCT user_id) AS active_cutomer
FROM orders;

-- Repeat customers (more than 1 order)
SELECT count(*) AS repeat_customers
FROM (
SELECT 
	COUNT(user_id) as customer_order_times
FROM orders
GROUP BY user_id
HAVING COUNT(user_id) > 1)t;

-- Customer Lifetime Value (LTV)
SELECT 
	u.id AS customer_id,
    u.name AS customer_name,
    SUM(o.total_amount) AS total_lifetime_value
FROM orders o
RIGHT JOIN users u
ON o.user_id = u.id
GROUP BY u.id, u.name
ORDER BY total_lifetime_value DESC;

-- Users who spent more than 5000
SELECT 
	u.id AS customer_id,
    u.name AS customer_name,
    SUM(o.total_amount) AS total_spend
FROM orders o
RIGHT JOIN users u
ON o.user_id = u.id
GROUP BY u.id, u.name
HAVING total_spend > 5000
ORDER BY total_spend DESC;

-- ============================================================
-- Operations KPIs
-- ============================================================
-- Order fulfilment rate
SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN status = 'delivered' THEN 1 ELSE 0 END) AS delivered,
    ROUND(SUM(CASE WHEN status = 'delivered' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS fulfilment_rate_pct
FROM orders;

-- Cancellation rate
SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled,
    ROUND(SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS Cancellation_rate_pct
FROM orders;

-- Payment success rate
SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS paymented,
    ROUND(SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS payment_rate_pct
FROM payments;

-- Low stock alert
SELECT 
	id AS product_id,
    name AS product_name,
    stock_qty
FROM products
WHERE stock_qty < 50
ORDER BY stock_qty;

-- Top 5 best-selling products
SELECT p.name, SUM(oi.quantity) AS units_sold
FROM products p
JOIN order_items oi 
ON p.id = oi.product_id
GROUP BY p.id, p.name
ORDER BY units_sold DESC
LIMIT 5;

-- Sales Summary Report
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(DISTINCT o.user_id)        AS unique_customers,
    COUNT(o.id)                      AS total_orders,
    SUM(CASE WHEN o.status='delivered' THEN 1 ELSE 0 END) AS delivered,
    SUM(CASE WHEN o.status='cancelled' THEN 1 ELSE 0 END) AS cancelled,
    SUM(CASE WHEN o.status = 'completed' THEN amount ELSE 0 END)     AS revenue
FROM orders o
LEFT JOIN payments p ON o.id = p.order_id
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- Product Performance Report
SELECT
    c.name           AS category,
    p.name           AS product,
    p.price          AS unit_price,
    p.stock_qty      AS current_stock,
    COALESCE(SUM(oi.quantity), 0) AS units_sold,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_revenue
FROM products p
JOIN categories c        ON p.category_id = c.id
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o       ON oi.order_id = o.id AND o.status != 'cancelled'
GROUP BY c.name, p.id, p.name, p.price, p.stock_qty
ORDER BY total_revenue DESC;

-- using the View for Reporting
-- Use the vw_order_summary view to generate reports
SELECT * FROM vw_order_summary
WHERE order_status = 'delivered'
ORDER BY order_date DESC;

-- Revenue by payment method
SELECT pay_method,
       COUNT(*) AS transactions,
       SUM(total_bill) AS revenue
FROM vw_order_summary
WHERE pay_status = 'completed'
GROUP BY pay_method;
