CREATE DATABASE E_Commerce_db;
USE E_Commerce_db;
-- ============================================================
-- Create Tables
-- ============================================================
 CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);
 
CREATE TABLE users (
    id  INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
	email VARCHAR(100),
    phone VARCHAR(20) NOT NULL UNIQUE,
    address  TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
 
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL REFERENCES categories(id),
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock_qty INT NOT NULL DEFAULT 0 CHECK (stock_qty >= 0)
);
 
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id      INT NOT NULL REFERENCES users(id),
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    status       VARCHAR(20) NOT NULL DEFAULT 'pending'
                     CHECK (status IN ('pending','processing','shipped','delivered','cancelled')),
    order_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
 
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id    INT NOT NULL REFERENCES orders(id),
    product_id  INT NOT NULL REFERENCES products(id),
    quantity    INT NOT NULL CHECK (quantity > 0),
    unit_price  DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0)
);
 
CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id     INT NOT NULL UNIQUE REFERENCES orders(id),
    amount       DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    method       VARCHAR(30) NOT NULL CHECK (method IN ('credit_card','debit_card','mobile_banking','cash_on_delivery')),
    status       VARCHAR(20) NOT NULL DEFAULT 'pending'
                     CHECK (status IN ('pending','completed','failed','refunded')),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- ============================================================
-- Create Tables
-- ============================================================
-- Categories
INSERT INTO categories (name, description) VALUES
('Electronics',     'Gadgets, devices and accessories'),
('Clothing',        'Men and women apparel'),
('Books',           'Academic and recreational books'),
('Home & Kitchen',  'Furniture and kitchen essentials'),
('Sports & Fitness','Exercise equipment and sportswear');
 
 -- Users
 INSERT INTO users (name, email, phone, address) VALUES
('Alice Rahman',    'alice@example.com',   '01711000001', 'Dhaka, Bangladesh'),
('Bob Hossain',     'bob@example.com',     '01711000002', 'Chittagong, Bangladesh'),
('Carol Islam',     'carol@example.com',   '01711000003', 'Sylhet, Bangladesh'),
('David Chowdhury', 'david@example.com',   '01711000004', 'Khulna, Bangladesh'),
('Eva Begum',       'eva@example.com',     '01711000005', 'Rajshahi, Bangladesh'),
('Frank Ahmed',     'frank@example.com',   '01711000006', 'Dhaka, Bangladesh'),
('Grace Noor',      'grace@example.com',   '01711000007', 'Barisal, Bangladesh'),
('Hasan Malik',     'hasan@example.com',   '01711000008', 'Mymensingh, Bangladesh'),
('Irfan Uddin',     'irfan@example.com',   '01711000009', 'Dhaka, Bangladesh'),
('Jannatul Ferdous','jannatul@example.com','01711000010', 'Comilla, Bangladesh');

-- Products
INSERT INTO products (category_id, name, description, price, stock_qty) VALUES
(1, 'Smartphone X12',       'Latest Android smartphone',          25000.00, 50),
(1, 'Wireless Earbuds',     'Noise-cancelling Bluetooth earbuds',  3500.00, 100),
(1, 'Laptop Pro 15',        '15-inch core i7 laptop',             75000.00, 20),
(1, 'Smart Watch S2',       'Fitness and notification smartwatch',  8000.00, 40),
(2, 'Men\'s Polo Shirt',    'Cotton polo shirt, multiple colors',    800.00, 200),
(2, 'Women\'s Kurti',       'Designer cotton kurti',               1200.00, 150),
(2, 'Sports Sneakers',      'Lightweight running shoes',           3500.00, 80),
(3, 'Data Structures Book', 'Comprehensive DSA reference book',    1500.00, 60),
(3, 'English Grammar Guide','Complete grammar handbook',            600.00, 90),
(4, 'Non-stick Frying Pan', '28cm induction compatible pan',       2200.00, 45),
(4, 'Bedsheet Set',         'King size 100% cotton bedsheet',      2500.00, 55),
(4, 'Study Lamp',           'LED adjustable desk lamp',            1100.00, 70),
(5, 'Yoga Mat',             'Anti-slip 6mm thick yoga mat',         900.00, 120),
(5, 'Dumbell Set 10kg',     'Rubber coated dumbbell pair',         3000.00, 35),
(5, 'Jump Rope',            'Speed skipping rope with counter',     450.00, 200);

-- Orders
INSERT INTO orders (user_id, total_amount, status, order_date) VALUES
(1,  28500.00, 'delivered',   '2024-01-05 10:00:00'),
(1,   3500.00, 'delivered',   '2024-01-20 11:00:00'),
(2,  75000.00, 'shipped',     '2024-02-03 09:30:00'),
(2,   2000.00, 'delivered',   '2024-02-15 14:00:00'),
(3,  25000.00, 'delivered',   '2024-02-20 16:00:00'),
(3,   1800.00, 'processing',  '2024-03-01 10:30:00'),
(4,   8000.00, 'delivered',   '2024-03-10 12:00:00'),
(4,   3200.00, 'cancelled',   '2024-03-15 09:00:00'),
(5,   4400.00, 'delivered',   '2024-03-22 15:00:00'),
(5,   1350.00, 'pending',     '2024-04-01 08:00:00'),
(6,  11200.00, 'delivered',   '2024-04-05 11:00:00'),
(6,   2100.00, 'shipped',     '2024-04-10 13:00:00'),
(7,   5700.00, 'delivered',   '2024-04-18 10:00:00'),
(7,   1500.00, 'delivered',   '2024-04-25 09:30:00'),
(8,   9500.00, 'delivered',   '2024-05-02 14:00:00'),
(8,   2700.00, 'processing',  '2024-05-10 11:30:00'),
(9,  33500.00, 'delivered',   '2024-05-15 16:00:00'),
(9,   4500.00, 'shipped',     '2024-05-20 10:00:00'),
(10,  7200.00, 'delivered',   '2024-05-25 12:00:00'),
(10,  1050.00, 'pending',     '2024-06-01 09:00:00');

-- Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1,  1, 1, 25000.00),
(1,  2, 1,  3500.00),
(2,  2, 1,  3500.00),
(3,  3, 1, 75000.00),
(4,  9, 2,    600.00),
(4, 15, 1,    450.00),
(5,  1, 1, 25000.00),
(6,  8, 1,  1500.00),
(6, 13, 1,    900.00),
(7,  4, 1,  8000.00),
(8,  7, 1,  3500.00),
(9, 10, 1,  2200.00),
(9, 13, 2,    900.00),
(10, 9, 1,    600.00),
(10,15, 1,    450.00),
(11, 4, 1,  8000.00),
(11,12, 3,  1100.00),
(12,14, 1,  3000.00),
(13, 5, 2,    800.00),
(13, 6, 1,  1200.00),
(13,13, 1,    900.00),
(14, 8, 1,  1500.00),
(15, 1, 1, 25000.00),
(15,14, 1,  3000.00),
(16,11, 1,  2500.00),
(17, 3, 1, 75000.00),
(18, 2, 1,  3500.00),
(18, 7, 1,  3500.00),
(19, 4, 1,  8000.00),
(20,15, 2,    450.00);

-- Payments
INSERT INTO payments (order_id, amount, method, status) VALUES
(1,  28500.00, 'bikash',  'completed'),
(2,   3500.00, 'credit_card',     'completed'),
(3,  75000.00, 'credit_card',     'completed'),
(4,   2000.00, 'cash_on_delivery','completed'),
(5,  25000.00, 'debit_card',      'completed'),
(6,   1800.00, 'bikash',  'pending'),
(7,   8000.00, 'credit_card',     'completed'),
(8,   3200.00, 'cash_on_delivery','refunded'),
(9,   4400.00, 'bikash',  'completed'),
(10,  1350.00, 'bikash',  'pending'),
(11, 11200.00, 'credit_card',     'completed'),
(12,  2100.00, 'debit_card',      'completed'),
(13,  5700.00, 'bikash',  'completed'),
(14,  1500.00, 'cash_on_delivery','completed'),
(15,  9500.00, 'credit_card',     'completed'),
(16,  2700.00, 'bikash',  'pending'),
(17, 33500.00, 'credit_card',     'completed'),
(18,  4500.00, 'debit_card',      'completed'),
(19,  7200.00, 'bikash',  'completed'),
(20,  1050.00, 'cash_on_delivery','pending');

-- Performance Optimization
CREATE INDEX idx_orders_user_id       ON orders(user_id);
CREATE INDEX idx_orders_order_date    ON orders(order_date);
CREATE INDEX idx_orders_status        ON orders(status);
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product  ON order_items(product_id);
CREATE INDEX idx_payments_order_id    ON payments(order_id);
