-- ============================================================
-- Products module schema (fresh install)
-- Database: lms
-- No soft delete — permanent DELETE only
-- ============================================================

USE lms;

-- ============================================================
-- PRODUCTS
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
  vendor VARCHAR(255),
  product_type VARCHAR(255),
  price DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  offer_price DECIMAL(12,2) DEFAULT 0.00,
  discount_percentage INT DEFAULT 0,
  cost_price DECIMAL(12,2) DEFAULT 0.00,
  stock INT DEFAULT 0,
  stock_status ENUM('in_stock', 'out_of_stock', 'low_stock') DEFAULT 'in_stock',
  low_stock_threshold INT DEFAULT 5,
  short_description TEXT,
  long_description LONGTEXT,
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
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
  FOREIGN KEY (sub_category_id) REFERENCES sub_categories(id) ON DELETE SET NULL,
  FOREIGN KEY (child_category_id) REFERENCES child_categories(id) ON DELETE SET NULL,
  INDEX idx_products_slug (slug),
  INDEX idx_products_sku (sku),
  INDEX idx_products_category (category_id),
  INDEX idx_products_brand (brand),
  INDEX idx_products_status (status),
  INDEX idx_products_featured (is_featured),
  INDEX idx_products_trending (is_trending),
  INDEX idx_products_bestseller (is_best_seller),
  INDEX idx_products_stock (stock),
  FULLTEXT INDEX idx_products_search (name, short_description, tags)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- PRODUCT IMAGES
-- ============================================================

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- PRODUCT VARIANT OPTIONS
-- ============================================================

CREATE TABLE IF NOT EXISTS product_variant_options (
  id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT NOT NULL,
  option_name VARCHAR(100) NOT NULL,
  option_values JSON NOT NULL,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_pvo_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- PRODUCT VARIANTS
-- ============================================================

CREATE TABLE IF NOT EXISTS product_variants (
  id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT NOT NULL,
  sku VARCHAR(100),
  size VARCHAR(50),
  color VARCHAR(50),
  option_values JSON,
  price DECIMAL(12,2),
  offer_price DECIMAL(12,2),
  stock INT DEFAULT 0,
  image VARCHAR(500),
  status ENUM('active', 'inactive') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_product_variants_product (product_id),
  INDEX idx_product_variants_sku (sku)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- PRODUCT SEO
-- ============================================================

CREATE TABLE IF NOT EXISTS product_seo (
  id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT NOT NULL UNIQUE,
  seo_title VARCHAR(255),
  seo_description TEXT,
  keywords TEXT,
  canonical_url VARCHAR(500),
  meta_robots VARCHAR(50) DEFAULT 'index,follow',
  og_title VARCHAR(255),
  og_description TEXT,
  og_image VARCHAR(500),
  twitter_title VARCHAR(255),
  twitter_description TEXT,
  twitter_image VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_product_seo_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- COLLECTIONS
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
  INDEX idx_collections_slug (slug),
  INDEX idx_collections_status (status),
  INDEX idx_collections_sort (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- COLLECTION PRODUCTS (junction)
-- ============================================================

CREATE TABLE IF NOT EXISTS collection_products (
  id INT PRIMARY KEY AUTO_INCREMENT,
  collection_id INT NOT NULL,
  product_id INT NOT NULL,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (collection_id) REFERENCES collections(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  UNIQUE KEY unique_collection_product (collection_id, product_id),
  INDEX idx_collection_products_collection (collection_id),
  INDEX idx_collection_products_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- COUPONS
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
  expiry_date DATE,
  status ENUM('active', 'inactive', 'expired') DEFAULT 'active',
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_coupons_code (code),
  INDEX idx_coupons_status (status),
  INDEX idx_coupons_expiry (expiry_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- COUPON USAGE
-- ============================================================

CREATE TABLE IF NOT EXISTS coupon_usage (
  id INT PRIMARY KEY AUTO_INCREMENT,
  coupon_id INT NOT NULL,
  customer_id INT,
  order_id INT,
  discount_amount DECIMAL(10,2) DEFAULT 0.00,
  used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE CASCADE,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
  INDEX idx_coupon_usage_coupon (coupon_id),
  INDEX idx_coupon_usage_customer (customer_id),
  INDEX idx_coupon_usage_order (order_id),
  INDEX idx_coupon_usage_used_at (used_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- UPGRADE EXISTING DATABASES
-- ============================================================

-- Ensure thumbnail column exists on products (ignore error if column already exists)
-- ALTER TABLE products ADD COLUMN thumbnail VARCHAR(500) AFTER tags;

-- Remove legacy columns on upgrade (run once; ignore errors if already dropped)
-- ALTER TABLE products DROP COLUMN deleted_at;
-- ALTER TABLE products DROP COLUMN size;
-- ALTER TABLE products DROP COLUMN color;
-- ALTER TABLE products DROP COLUMN material;
-- ALTER TABLE products DROP COLUMN fabric;
-- ALTER TABLE products DROP COLUMN occasion;

-- Ensure variant option_values column exists
-- ALTER TABLE product_variants ADD COLUMN option_values JSON NULL AFTER color;
