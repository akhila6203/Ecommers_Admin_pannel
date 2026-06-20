-- ============================================================
-- Orders module schema
-- Database: lms
-- No soft delete — permanent DELETE only
-- ============================================================

USE lms;

-- ============================================================
-- ORDERS
-- ============================================================

CREATE TABLE IF NOT EXISTS orders (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_number VARCHAR(50) NOT NULL UNIQUE,
  customer_id INT,
  admin_id INT,
  email VARCHAR(255),
  phone VARCHAR(20),
  billing_address_id INT,
  shipping_address_id INT,
  shipping_name VARCHAR(255),
  shipping_phone VARCHAR(20),
  shipping_address VARCHAR(500),
  shipping_city VARCHAR(100),
  shipping_state VARCHAR(100),
  shipping_pincode VARCHAR(10),
  shipping_country VARCHAR(100) DEFAULT 'India',
  billing_name VARCHAR(255),
  billing_phone VARCHAR(20),
  billing_address VARCHAR(500),
  billing_city VARCHAR(100),
  billing_state VARCHAR(100),
  billing_pincode VARCHAR(10),
  billing_country VARCHAR(100) DEFAULT 'India',
  subtotal DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  discount_amount DECIMAL(12,2) DEFAULT 0.00,
  coupon_id INT,
  coupon_code VARCHAR(50),
  discount_type VARCHAR(20),
  shipping_charge DECIMAL(10,2) DEFAULT 0.00,
  tax_amount DECIMAL(12,2) DEFAULT 0.00,
  gst_amount DECIMAL(12,2) DEFAULT 0.00,
  total_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  paid_amount DECIMAL(12,2) DEFAULT 0.00,
  due_amount DECIMAL(12,2) DEFAULT 0.00,
  payment_method VARCHAR(50) DEFAULT 'cod',
  payment_status ENUM('pending', 'paid', 'failed', 'refunded', 'partially_refunded') DEFAULT 'pending',
  payment_id VARCHAR(255),
  payment_gateway VARCHAR(50),
  payment_reference VARCHAR(255),
  -- payment_gateway VARCHAR(50),
  -- payment_reference VARCHAR(255),
  order_status ENUM('pending', 'confirmed', 'packed', 'shipped', 'delivered', 'cancelled', 'returned', 'refunded') DEFAULT 'pending',
  shipping_method VARCHAR(100),
  tracking_number VARCHAR(255),
  tracking_url VARCHAR(500),
  estimated_delivery DATE,
  delivered_at TIMESTAMP NULL,
  notes TEXT,
  admin_notes TEXT,
  is_paid TINYINT(1) DEFAULT 0,
  is_cod TINYINT(1) DEFAULT 0,
  invoice_number VARCHAR(100),
  invoice_generated_at TIMESTAMP NULL,
  created_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL,
  INDEX idx_orders_number (order_number),
  INDEX idx_orders_customer (customer_id),
  INDEX idx_orders_status (order_status),
  INDEX idx_orders_payment (payment_status),
  INDEX idx_orders_created (created_at),
  INDEX idx_orders_invoice (invoice_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- ORDER ITEMS
-- ============================================================

CREATE TABLE IF NOT EXISTS order_items (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  product_id INT,
  product_name VARCHAR(500) NOT NULL,
  product_sku VARCHAR(100),
  variant_id INT,
  variant_info JSON,
  quantity INT NOT NULL DEFAULT 1,
  price DECIMAL(12,2) NOT NULL,
  offer_price DECIMAL(12,2),
  total_price DECIMAL(12,2) NOT NULL,
  gst_percent DECIMAL(5,2) DEFAULT 0.00,
  gst_amount DECIMAL(12,2) DEFAULT 0.00,
  image VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL,
  INDEX idx_order_items_order (order_id),
  INDEX idx_order_items_product (product_id),
  INDEX idx_order_items_variant (variant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- ORDER TIMELINE
-- ============================================================

CREATE TABLE IF NOT EXISTS order_timeline (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  status VARCHAR(50) NOT NULL,
  note TEXT,
  created_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  INDEX idx_order_timeline_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- ORDER NOTES
-- ============================================================

CREATE TABLE IF NOT EXISTS order_notes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  note TEXT NOT NULL,
  note_type ENUM('admin', 'customer', 'system') DEFAULT 'admin',
  is_visible_to_customer TINYINT(1) DEFAULT 0,
  created_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  INDEX idx_order_notes_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- UPGRADE EXISTING DATABASES
-- ============================================================

-- Upgrade existing databases (ignore errors if columns already exist)
-- ALTER TABLE orders ADD COLUMN payment_gateway VARCHAR(50) AFTER payment_id;
-- ALTER TABLE orders ADD COLUMN payment_reference VARCHAR(255) AFTER payment_gateway;
-- ALTER TABLE order_items ADD COLUMN variant_id INT AFTER product_sku;
-- ALTER TABLE order_items ADD COLUMN variant_info JSON AFTER variant_id;
-- ALTER TABLE orders DROP COLUMN deleted_at;

-- ============================================================
-- DUMMY DATA (optional — run manually for testing)
-- Requires customers from database/customers.sql
-- ============================================================

INSERT INTO orders (
  order_number, customer_id, email, phone,
  shipping_name, shipping_phone, shipping_address, shipping_city, shipping_state, shipping_pincode,
  billing_name, billing_phone, billing_address, billing_city, billing_state, billing_pincode,
  subtotal, discount_amount, shipping_charge, tax_amount, total_amount,
  payment_method, payment_status, order_status, is_paid, is_cod
)
SELECT * FROM (
  SELECT 'ORD-20250620-001', c.id, c.email, c.phone,
    CONCAT(c.first_name, ' ', c.last_name), c.phone, COALESCE(c.address_line1, CONCAT(c.city, ' Address')), c.city, c.state, c.pincode,
    CONCAT(c.first_name, ' ', c.last_name), c.phone, COALESCE(c.address_line1, CONCAT(c.city, ' Address')), c.city, c.state, c.pincode,
    2499.00, 200.00, 99.00, 450.00, 2848.00,
    'razorpay', 'paid', 'delivered', 1, 0
  FROM customers c WHERE c.email = 'rahul.sharma@example.com'
  UNION ALL
  SELECT 'ORD-20250620-002', c.id, c.email, c.phone,
    CONCAT(c.first_name, ' ', c.last_name), c.phone, CONCAT(c.city, ' Main Road'), c.city, c.state, c.pincode,
    CONCAT(c.first_name, ' ', c.last_name), c.phone, CONCAT(c.city, ' Main Road'), c.city, c.state, c.pincode,
    1750.00, 0.00, 0.00, 315.00, 2065.00,
    'cod', 'pending', 'pending', 0, 1
  FROM customers c WHERE c.email = 'rahul.sharma@example.com'
  UNION ALL
  SELECT 'ORD-20250620-003', c.id, c.email, c.phone,
    CONCAT(c.first_name, ' ', c.last_name), c.phone, CONCAT(c.city, ' Colony'), c.city, c.state, c.pincode,
    CONCAT(c.first_name, ' ', c.last_name), c.phone, CONCAT(c.city, ' Colony'), c.city, c.state, c.pincode,
    1299.00, 100.00, 49.00, 234.00, 1482.00,
    'razorpay', 'paid', 'shipped', 1, 0
  FROM customers c WHERE c.email = 'priya.reddy@example.com'
) AS seed
WHERE NOT EXISTS (SELECT 1 FROM orders WHERE order_number = 'ORD-20250620-001');

INSERT INTO order_items (order_id, product_id, product_name, product_sku, quantity, price, offer_price, total_price, gst_percent, gst_amount)
SELECT o.id, NULL, 'Cotton Kurta Set', 'SKU-KURTA-001', 1, 2499.00, 2299.00, 2299.00, 18.00, 413.82
FROM orders o WHERE o.order_number = 'ORD-20250620-001'
  AND NOT EXISTS (SELECT 1 FROM order_items oi WHERE oi.order_id = o.id);

INSERT INTO order_items (order_id, product_id, product_name, product_sku, quantity, price, offer_price, total_price, gst_percent, gst_amount)
SELECT o.id, NULL, 'Printed Saree', 'SKU-SAREE-002', 1, 1750.00, 1750.00, 1750.00, 18.00, 315.00
FROM orders o WHERE o.order_number = 'ORD-20250620-002'
  AND NOT EXISTS (SELECT 1 FROM order_items oi WHERE oi.order_id = o.id);

INSERT INTO order_items (order_id, product_id, product_name, product_sku, quantity, price, offer_price, total_price, gst_percent, gst_amount)
SELECT o.id, NULL, 'Designer Handbag', 'SKU-BAG-003', 1, 1299.00, 1199.00, 1199.00, 18.00, 215.82
FROM orders o WHERE o.order_number = 'ORD-20250620-003'
  AND NOT EXISTS (SELECT 1 FROM order_items oi WHERE oi.order_id = o.id);

INSERT INTO order_timeline (order_id, status, note)
SELECT o.id, 'pending', 'Order placed'
FROM orders o WHERE o.order_number IN ('ORD-20250620-001', 'ORD-20250620-002', 'ORD-20250620-003')
  AND NOT EXISTS (SELECT 1 FROM order_timeline ot WHERE ot.order_id = o.id AND ot.status = 'pending');
