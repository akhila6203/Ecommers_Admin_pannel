-- ============================================================
-- Migration V2: Product Module Enhancements
-- Adds product_seo and product_variant_options tables
-- ============================================================

USE lms;

-- 1. PRODUCT SEO TABLE
-- Extended SEO fields for rich social media and search engine optimization
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
) ENGINE=InnoDB;

-- 2. PRODUCT VARIANT OPTIONS TABLE
-- Defines variant option types and values per product (e.g., Size: [S,M,L], Color: [Red,Blue])
-- Used as blueprint to auto-generate variant combinations
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
) ENGINE=InnoDB;