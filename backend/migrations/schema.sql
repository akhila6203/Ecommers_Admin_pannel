-- ============================================================
-- LM Shopping Mall - Complete Database Schema
-- Database: lms
-- ============================================================

CREATE DATABASE IF NOT EXISTS lms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE lms;

-- ============================================================
-- 1. ROLES & PERMISSIONS
-- ============================================================

CREATE TABLE IF NOT EXISTS roles (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL UNIQUE,
  slug VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  permissions JSON,
  status ENUM('active', 'inactive') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS permissions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) NOT NULL UNIQUE,
  module VARCHAR(100) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS role_permissions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  role_id INT NOT NULL,
  permission_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE,
  UNIQUE KEY unique_role_permission (role_id, permission_id)
) ENGINE=InnoDB;

-- ============================================================
-- 2. ADMINS
-- ============================================================

CREATE TABLE IF NOT EXISTS admins (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  role VARCHAR(50) DEFAULT 'admin',
  role_id INT,
  avatar VARCHAR(500),
  status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
  email_verified_at TIMESTAMP NULL,
  last_login_at TIMESTAMP NULL,
  last_login_ip VARCHAR(45),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE SET NULL,
  INDEX idx_admins_email (email),
  INDEX idx_admins_status (status),
  INDEX idx_admins_role (role)
) ENGINE=InnoDB;

-- ============================================================
-- 3. PASSWORD RESETS & REFRESH TOKENS
-- ============================================================

CREATE TABLE IF NOT EXISTS password_resets (
  id INT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) NOT NULL,
  token VARCHAR(255) NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  used_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_password_resets_email (email),
  INDEX idx_password_resets_token (token)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS refresh_tokens (
  id INT PRIMARY KEY AUTO_INCREMENT,
  admin_id INT,
  customer_id INT,
  token VARCHAR(500) NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  revoked_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_refresh_tokens_token (token),
  INDEX idx_refresh_tokens_admin (admin_id),
  INDEX idx_refresh_tokens_customer (customer_id)
) ENGINE=InnoDB;

-- ============================================================
-- 4. CUSTOMERS
-- ============================================================

CREATE TABLE IF NOT EXISTS customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  avatar VARCHAR(500),
  gender ENUM('male', 'female', 'other') DEFAULT NULL,
  date_of_birth DATE,
  status ENUM('active', 'inactive', 'blocked') DEFAULT 'active',
  email_verified_at TIMESTAMP NULL,
  last_login_at TIMESTAMP NULL,
  total_orders INT DEFAULT 0,
  total_spent DECIMAL(12,2) DEFAULT 0.00,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  INDEX idx_customers_email (email),
  INDEX idx_customers_status (status),
  INDEX idx_customers_phone (phone)
) ENGINE=InnoDB;

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
) ENGINE=InnoDB;

-- ============================================================
-- 5. CATEGORIES (3-Level Structure)
-- ============================================================

CREATE TABLE IF NOT EXISTS categories (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL UNIQUE,
  description TEXT,
  image VARCHAR(500),
  icon VARCHAR(255),
  status ENUM('active', 'inactive') DEFAULT 'active',
  sort_order INT DEFAULT 0,
  meta_title VARCHAR(255),
  meta_description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_categories_slug (slug),
  INDEX idx_categories_status (status)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS sub_categories (
  id INT PRIMARY KEY AUTO_INCREMENT,
  main_category_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL,
  description TEXT,
  image VARCHAR(500),
  status ENUM('active', 'inactive') DEFAULT 'active',
  sort_order INT DEFAULT 0,
  meta_title VARCHAR(255),
  meta_description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (main_category_id) REFERENCES categories(id) ON DELETE CASCADE,
  INDEX idx_sub_categories_slug (slug),
  INDEX idx_sub_categories_main (main_category_id),
  INDEX idx_sub_categories_status (status)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS child_categories (
  id INT PRIMARY KEY AUTO_INCREMENT,
  sub_category_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL,
  description TEXT,
  image VARCHAR(500),
  status ENUM('active', 'inactive') DEFAULT 'active',
  sort_order INT DEFAULT 0,
  meta_title VARCHAR(255),
  meta_description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (sub_category_id) REFERENCES sub_categories(id) ON DELETE CASCADE,
  INDEX idx_child_categories_slug (slug),
  INDEX idx_child_categories_sub (sub_category_id),
  INDEX idx_child_categories_status (status)
) ENGINE=InnoDB;

-- ============================================================
-- 6. PRODUCTS
-- ============================================================

CREATE TABLE IF NOT EXISTS products (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(500) NOT NULL,
  slug VARCHAR(500) NOT NULL UNIQUE,
  sku VARCHAR(100) UNIQUE,
  category_id INT,
  sub_category_id INT,
  child_category_id INT,
  brand VARCHAR(255),
  price DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  offer_price DECIMAL(12,2) DEFAULT 0.00,
  discount_percentage INT DEFAULT 0,
  cost_price DECIMAL(12,2) DEFAULT 0.00,
  stock INT DEFAULT 0,
  stock_status ENUM('in_stock', 'out_of_stock', 'low_stock') DEFAULT 'in_stock',
  low_stock_threshold INT DEFAULT 5,
  size VARCHAR(255),
  color VARCHAR(255),
  material VARCHAR(255),
  fabric VARCHAR(255),
  occasion VARCHAR(255),
  weight DECIMAL(10,2),
  unit VARCHAR(20) DEFAULT 'pcs',
  short_description TEXT,
  long_description LONGTEXT,
  specifications JSON,
  tags TEXT,
  thumbnail VARCHAR(500),
  video_url VARCHAR(500),
  gst_percent DECIMAL(5,2) DEFAULT 0.00,
  shipping_charge DECIMAL(10,2) DEFAULT 0.00,
  is_featured TINYINT(1) DEFAULT 0,
  is_trending TINYINT(1) DEFAULT 0,
  is_best_seller TINYINT(1) DEFAULT 0,
  is_new_arrival TINYINT(1) DEFAULT 0,
  status ENUM('active', 'inactive', 'draft') DEFAULT 'active',
  meta_title VARCHAR(255),
  meta_description TEXT,
  meta_keywords TEXT,
  total_sales INT DEFAULT 0,
  avg_rating DECIMAL(3,2) DEFAULT 0.00,
  review_count INT DEFAULT 0,
  created_by INT,
  updated_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
  FOREIGN KEY (sub_category_id) REFERENCES sub_categories(id) ON DELETE SET NULL,
  FOREIGN KEY (child_category_id) REFERENCES child_categories(id) ON DELETE SET NULL,
  INDEX idx_products_slug (slug),
  INDEX idx_products_sku (sku),
  INDEX idx_products_category (category_id),
  INDEX idx_products_status (status),
  INDEX idx_products_featured (is_featured),
  INDEX idx_products_trending (is_trending),
  INDEX idx_products_bestseller (is_best_seller),
  INDEX idx_products_stock (stock),
  FULLTEXT INDEX idx_products_search (name, short_description, tags)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS product_images (
  id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT NOT NULL,
  image VARCHAR(500) NOT NULL,
  image_type ENUM('thumbnail', 'gallery') DEFAULT 'gallery',
  sort_order INT DEFAULT 0,
  alt_text VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_product_images_product (product_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS product_variants (
  id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT NOT NULL,
  sku VARCHAR(100),
  size VARCHAR(50),
  color VARCHAR(50),
  price DECIMAL(12,2),
  offer_price DECIMAL(12,2),
  stock INT DEFAULT 0,
  image VARCHAR(500),
  status ENUM('active', 'inactive') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_product_variants_product (product_id)
) ENGINE=InnoDB;

-- ============================================================
-- 7. INVENTORY
-- ============================================================

CREATE TABLE IF NOT EXISTS inventory (
  id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT NOT NULL,
  quantity INT NOT NULL DEFAULT 0,
  reserved_quantity INT DEFAULT 0,
  available_quantity INT DEFAULT 0,
  low_stock_threshold INT DEFAULT 5,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  UNIQUE KEY unique_inventory_product (product_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS inventory_logs (
  id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT NOT NULL,
  type ENUM('purchase', 'sale', 'adjustment', 'return', 'transfer') NOT NULL,
  quantity INT NOT NULL,
  previous_quantity INT,
  new_quantity INT,
  reference_type VARCHAR(100),
  reference_id INT,
  notes TEXT,
  created_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_inventory_logs_product (product_id),
  INDEX idx_inventory_logs_type (type),
  INDEX idx_inventory_logs_created (created_at)
) ENGINE=InnoDB;

-- ============================================================
-- 8. ORDERS
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
  deleted_at TIMESTAMP NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL,
  INDEX idx_orders_number (order_number),
  INDEX idx_orders_customer (customer_id),
  INDEX idx_orders_status (order_status),
  INDEX idx_orders_payment (payment_status),
  INDEX idx_orders_created (created_at),
  INDEX idx_orders_invoice (invoice_number)
) ENGINE=InnoDB;

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
  INDEX idx_order_items_product (product_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS order_timeline (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  status VARCHAR(50) NOT NULL,
  note TEXT,
  created_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  INDEX idx_order_timeline_order (order_id),
  INDEX idx_order_timeline_status (status)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS order_notes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  note TEXT NOT NULL,
  note_type ENUM('admin', 'customer', 'system') DEFAULT 'admin',
  created_by INT,
  is_visible_to_customer TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  INDEX idx_order_notes_order (order_id)
) ENGINE=InnoDB;

-- ============================================================
-- 9. COUPONS
-- ============================================================

CREATE TABLE IF NOT EXISTS coupons (
  id INT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE,
  type ENUM('percentage', 'flat') NOT NULL,
  value DECIMAL(10,2) NOT NULL,
  minimum_order_amount DECIMAL(10,2) DEFAULT 0.00,
  maximum_discount DECIMAL(10,2) DEFAULT 0.00,
  usage_limit INT DEFAULT 0,
  used_count INT DEFAULT 0,
  per_user_limit INT DEFAULT 1,
  is_for_new_customers TINYINT(1) DEFAULT 0,
  start_date DATE,
  expiry_date DATE NOT NULL,
  status ENUM('active', 'inactive', 'expired') DEFAULT 'active',
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_coupons_code (code),
  INDEX idx_coupons_status (status),
  INDEX idx_coupons_expiry (expiry_date)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS coupon_usages (
  id INT PRIMARY KEY AUTO_INCREMENT,
  coupon_id INT NOT NULL,
  customer_id INT,
  order_id INT,
  used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE CASCADE,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL,
  INDEX idx_coupon_usages_coupon (coupon_id),
  INDEX idx_coupon_usages_customer (customer_id)
) ENGINE=InnoDB;

-- ============================================================
-- 10. OFFERS
-- ============================================================

CREATE TABLE IF NOT EXISTS offers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL UNIQUE,
  type ENUM('category', 'product', 'festival', 'flash_sale', 'scheduled') NOT NULL,
  discount_type ENUM('percentage', 'flat') DEFAULT 'percentage',
  discount_value DECIMAL(10,2) NOT NULL,
  applicable_on JSON,
  minimum_purchase DECIMAL(10,2) DEFAULT 0.00,
  maximum_discount DECIMAL(10,2) DEFAULT 0.00,
  banner VARCHAR(500),
  start_date DATETIME NOT NULL,
  end_date DATETIME NOT NULL,
  is_featured TINYINT(1) DEFAULT 0,
  priority INT DEFAULT 0,
  status ENUM('active', 'inactive', 'scheduled', 'expired') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_offers_slug (slug),
  INDEX idx_offers_status (status),
  INDEX idx_offers_dates (start_date, end_date)
) ENGINE=InnoDB;

-- ============================================================
-- 11. BANNERS
-- ============================================================

CREATE TABLE IF NOT EXISTS banners (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255),
  subtitle VARCHAR(500),
  description TEXT,
  image VARCHAR(500) NOT NULL,
  mobile_image VARCHAR(500),
  type ENUM('homepage', 'slider', 'mobile', 'promotional', 'popup') DEFAULT 'homepage',
  position VARCHAR(50),
  link VARCHAR(500),
  button_text VARCHAR(100),
  button_link VARCHAR(500),
  sort_order INT DEFAULT 0,
  priority INT DEFAULT 0,
  start_date DATE,
  end_date DATE,
  status ENUM('active', 'inactive') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_banners_type (type),
  INDEX idx_banners_status (status),
  INDEX idx_banners_position (position)
) ENGINE=InnoDB;

-- ============================================================
-- 12. COLLECTIONS
-- ============================================================

CREATE TABLE IF NOT EXISTS collections (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL UNIQUE,
  description TEXT,
  image VARCHAR(500),
  banner VARCHAR(500),
  type VARCHAR(100),
  sort_order INT DEFAULT 0,
  status ENUM('active', 'inactive') DEFAULT 'active',
  meta_title VARCHAR(255),
  meta_description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  INDEX idx_collections_slug (slug),
  INDEX idx_collections_status (status)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS collection_products (
  id INT PRIMARY KEY AUTO_INCREMENT,
  collection_id INT NOT NULL,
  product_id INT NOT NULL,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  UNIQUE KEY unique_collection_product (collection_id, product_id)
) ENGINE=InnoDB;

-- ============================================================
-- 13. REVIEWS
-- ============================================================

CREATE TABLE IF NOT EXISTS reviews (
  id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT NOT NULL,
  customer_id INT,
  order_id INT,
  rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
  title VARCHAR(255),
  review TEXT,
  images JSON,
  is_verified_purchase TINYINT(1) DEFAULT 0,
  status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
  admin_reply TEXT,
  replied_at TIMESTAMP NULL,
  replied_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL,
  INDEX idx_reviews_product (product_id),
  INDEX idx_reviews_customer (customer_id),
  INDEX idx_reviews_status (status),
  INDEX idx_reviews_rating (rating)
) ENGINE=InnoDB;

-- ============================================================
-- 14. WISHLIST & CART
-- ============================================================

CREATE TABLE IF NOT EXISTS wishlists (
  id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  product_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  UNIQUE KEY unique_wishlist (customer_id, product_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS cart (
  id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  session_id VARCHAR(255),
  product_id INT NOT NULL,
  variant_id INT,
  quantity INT NOT NULL DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_cart_customer (customer_id),
  INDEX idx_cart_session (session_id)
) ENGINE=InnoDB;

-- ============================================================
-- 15. NOTIFICATIONS
-- ============================================================

CREATE TABLE IF NOT EXISTS notifications (
  id INT PRIMARY KEY AUTO_INCREMENT,
  type VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  data JSON,
  channel ENUM('email', 'sms', 'push', 'in_app', 'all') DEFAULT 'in_app',
  recipient_type ENUM('admin', 'customer', 'all', 'specific') DEFAULT 'all',
  recipient_id INT,
  sent_at TIMESTAMP NULL,
  is_read TINYINT(1) DEFAULT 0,
  read_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_notifications_type (type),
  INDEX idx_notifications_recipient (recipient_type, recipient_id),
  INDEX idx_notifications_read (is_read)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS email_templates (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL UNIQUE,
  subject VARCHAR(500) NOT NULL,
  body LONGTEXT NOT NULL,
  variables JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- 16. SETTINGS
-- ============================================================

CREATE TABLE IF NOT EXISTS settings (
  id INT PRIMARY KEY AUTO_INCREMENT,
  group_name VARCHAR(100) NOT NULL,
  key_name VARCHAR(100) NOT NULL,
  value LONGTEXT,
  type ENUM('text', 'number', 'boolean', 'json', 'image', 'email') DEFAULT 'text',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY unique_setting (group_name, key_name)
) ENGINE=InnoDB;

-- ============================================================
-- 17. LOGS
-- ============================================================

CREATE TABLE IF NOT EXISTS activity_logs (
  id INT PRIMARY KEY AUTO_INCREMENT,
  admin_id INT,
  customer_id INT,
  action VARCHAR(100) NOT NULL,
  description TEXT,
  ip_address VARCHAR(45),
  user_agent TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_activity_logs_admin (admin_id),
  INDEX idx_activity_logs_customer (customer_id),
  INDEX idx_activity_logs_action (action),
  INDEX idx_activity_logs_created (created_at)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS audit_logs (
  id INT PRIMARY KEY AUTO_INCREMENT,
  admin_id INT,
  action VARCHAR(100) NOT NULL,
  entity VARCHAR(100) NOT NULL,
  entity_id INT,
  details JSON,
  ip_address VARCHAR(45),
  user_agent TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_audit_logs_admin (admin_id),
  INDEX idx_audit_logs_entity (entity, entity_id),
  INDEX idx_audit_logs_action (action),
  INDEX idx_audit_logs_created (created_at)
) ENGINE=InnoDB;

-- ============================================================
-- 18. MEDIA
-- ============================================================

CREATE TABLE IF NOT EXISTS media (
  id INT PRIMARY KEY AUTO_INCREMENT,
  filename VARCHAR(255) NOT NULL,
  original_name VARCHAR(500) NOT NULL,
  path VARCHAR(500) NOT NULL,
  url VARCHAR(500) NOT NULL,
  type VARCHAR(50),
  size INT,
  width INT,
  height INT,
  mime_type VARCHAR(100),
  folder VARCHAR(255) DEFAULT 'general',
  alt_text VARCHAR(255),
  uploaded_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_media_folder (folder),
  INDEX idx_media_type (type),
  INDEX idx_media_uploader (uploaded_by)
) ENGINE=InnoDB;

-- ============================================================
-- Insert Default Data
-- ============================================================

-- Default Roles
INSERT INTO roles (name, slug, description) VALUES
('Super Admin', 'super-admin', 'Full access to all features'),
('Admin', 'admin', 'Administrative access with limited controls'),
('Manager', 'manager', 'Can manage products, orders, and customers'),
('Staff', 'staff', 'Limited staff access')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- Default Admin (password: admin123)
INSERT INTO admins (name, email, password, role, status) VALUES
('Super Admin', 'admin@lms.com', '$2a$12$LJ3m4ys3Lk0TSwHnbfOMiOXPm1Qlq5Jq5D5Q5q5Q5q5Q5q5Q5q5Q5', 'super_admin', 'active')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- Default Settings
INSERT INTO settings (group_name, key_name, value, type) VALUES
('general', 'store_name', 'LM Shopping Mall', 'text'),
('general', 'store_email', 'info@lmshoppingmall.com', 'email'),
('general', 'store_phone', '+91 9876543210', 'text'),
('general', 'store_address', '123, Fashion Street, Mumbai - 400001', 'text'),
('general', 'store_currency', 'INR', 'text'),
('general', 'store_currency_symbol', '₹', 'text'),
('general', 'store_timezone', 'Asia/Kolkata', 'text'),
('general', 'store_language', 'en', 'text'),
('seo', 'meta_title', 'LM Shopping Mall - Premium Fashion Store', 'text'),
('seo', 'meta_description', 'Shop premium sarees, kurtis, lehengas and more at LM Shopping Mall', 'text'),
('seo', 'meta_keywords', 'sarees, kurtis, lehengas, fashion, ethnic wear', 'text'),
('smtp', 'smtp_host', 'smtp.gmail.com', 'text'),
('smtp', 'smtp_port', '587', 'text'),
('smtp', 'smtp_secure', 'false', 'text'),
('payment', 'cod_enabled', 'true', 'boolean'),
('payment', 'online_payment_enabled', 'true', 'boolean'),
('shipping', 'free_shipping_minimum', '499', 'text'),
('shipping', 'shipping_charge', '49', 'text'),
('invoice', 'invoice_prefix', 'INV', 'text'),
('invoice', 'invoice_footer', 'Thank you for shopping with LM Shopping Mall!', 'text'),
('social', 'facebook', 'https://facebook.com/lmshoppingmall', 'text'),
('social', 'instagram', 'https://instagram.com/lmshoppingmall', 'text'),
('social', 'youtube', 'https://youtube.com/@lmshoppingmall', 'text')
ON DUPLICATE KEY UPDATE value=VALUES(value);