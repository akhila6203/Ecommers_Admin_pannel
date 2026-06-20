-- ============================================================
-- Customers module schema
-- Database: lms
-- No soft delete — permanent DELETE only
-- ============================================================

USE lms;

-- ============================================================
-- CUSTOMERS
-- ============================================================

CREATE TABLE IF NOT EXISTS customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL DEFAULT '',
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL DEFAULT '',
  phone VARCHAR(20),
  avatar VARCHAR(500),
  gender ENUM('male', 'female', 'other') DEFAULT NULL,
  date_of_birth DATE,
  status ENUM('active', 'inactive', 'blocked') DEFAULT 'active',
  email_verified_at TIMESTAMP NULL,
  last_login_at TIMESTAMP NULL,
  total_orders INT DEFAULT 0,
  total_spent DECIMAL(12,2) DEFAULT 0.00,
  address_line1 VARCHAR(500),
  address_line2 VARCHAR(500),
  city VARCHAR(100),
  state VARCHAR(100),
  pincode VARCHAR(10),
  country VARCHAR(100) DEFAULT 'India',
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_customers_email (email),
  INDEX idx_customers_status (status),
  INDEX idx_customers_phone (phone),
  INDEX idx_customers_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- CUSTOMER ADDRESSES
-- ============================================================

CREATE TABLE IF NOT EXISTS customer_addresses (
  id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  address_type ENUM('billing', 'shipping', 'both') DEFAULT 'both',
  full_name VARCHAR(255) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  address_line1 VARCHAR(500) NOT NULL,
  address_line2 VARCHAR(500),
  city VARCHAR(100) NOT NULL,
  state VARCHAR(100) NOT NULL,
  pincode VARCHAR(10) NOT NULL,
  country VARCHAR(100) DEFAULT 'India',
  is_default TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
  INDEX idx_customer_addresses_customer (customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- UPGRADE EXISTING DATABASES
-- ============================================================

-- Add address columns if upgrading from older schema (ignore errors if columns exist)
-- ALTER TABLE customers ADD COLUMN address_line1 VARCHAR(500) AFTER total_spent;
-- ALTER TABLE customers ADD COLUMN address_line2 VARCHAR(500) AFTER address_line1;
-- ALTER TABLE customers ADD COLUMN city VARCHAR(100) AFTER address_line2;
-- ALTER TABLE customers ADD COLUMN state VARCHAR(100) AFTER city;
-- ALTER TABLE customers ADD COLUMN pincode VARCHAR(10) AFTER state;
-- ALTER TABLE customers ADD COLUMN country VARCHAR(100) DEFAULT 'India' AFTER pincode;

-- Remove soft delete column if present
-- ALTER TABLE customers DROP COLUMN deleted_at;

-- ============================================================
-- DUMMY DATA (optional — run manually for testing)
-- Password hash below is bcrypt for "password123"
-- ============================================================

INSERT INTO customers (first_name, last_name, email, password, phone, gender, status, city, state, pincode, country, total_orders, total_spent, address_line1)
SELECT * FROM (
  SELECT 'Rahul', 'Sharma', 'rahul.sharma@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '9876543210', 'male', 'active', 'Hyderabad', 'Telangana', '500001', 'India', 2, 4598.00, '12 MG Road'
  UNION ALL SELECT 'Priya', 'Reddy', 'priya.reddy@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '9876543211', 'female', 'active', 'Secunderabad', 'Telangana', '500003', 'India', 1, 1299.00, '45 Park Lane'
  UNION ALL SELECT 'Amit', 'Kumar', 'amit.kumar@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '9876543212', 'male', 'active', 'Warangal', 'Telangana', '506001', 'India', 0, 0.00, '78 Station Road'
  UNION ALL SELECT 'Sneha', 'Patel', 'sneha.patel@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '9876543213', 'female', 'blocked', 'Karimnagar', 'Telangana', '505001', 'India', 0, 0.00, '22 Market Street'
) AS seed
WHERE NOT EXISTS (SELECT 1 FROM customers WHERE email = 'rahul.sharma@example.com');
