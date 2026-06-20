-- v5: Remove soft delete from banners, coupons, offers, and category tables
-- Run against your `lms` database after backing up data.
-- Note: main categories are stored in the `categories` table (not `main_categories`).

USE lms;

-- ============================================================
-- 1. Permanently remove previously soft-deleted rows
-- ============================================================

DELETE FROM child_categories WHERE deleted_at IS NOT NULL;
DELETE FROM sub_categories WHERE deleted_at IS NOT NULL;
DELETE FROM categories WHERE deleted_at IS NOT NULL;
DELETE FROM banners WHERE deleted_at IS NOT NULL;
DELETE FROM coupons WHERE deleted_at IS NOT NULL;
DELETE FROM offers WHERE deleted_at IS NOT NULL;

-- ============================================================
-- 2. Drop deleted_at columns
-- ============================================================

ALTER TABLE banners DROP COLUMN deleted_at;
ALTER TABLE coupons DROP COLUMN deleted_at;
ALTER TABLE offers DROP COLUMN deleted_at;
ALTER TABLE categories DROP COLUMN deleted_at;
ALTER TABLE sub_categories DROP COLUMN deleted_at;
ALTER TABLE child_categories DROP COLUMN deleted_at;

-- ============================================================
-- 3. Reference CREATE TABLE definitions (fresh install)
-- ============================================================

-- Main categories (`categories` table)
-- CREATE TABLE IF NOT EXISTS categories (
--   id INT PRIMARY KEY AUTO_INCREMENT,
--   name VARCHAR(255) NOT NULL,
--   slug VARCHAR(255) NOT NULL UNIQUE,
--   description TEXT,
--   image VARCHAR(500),
--   icon VARCHAR(255),
--   status ENUM('active', 'inactive') DEFAULT 'active',
--   sort_order INT DEFAULT 0,
--   meta_title VARCHAR(255),
--   meta_description TEXT,
--   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--   INDEX idx_categories_slug (slug),
--   INDEX idx_categories_status (status)
-- ) ENGINE=InnoDB;

-- CREATE TABLE IF NOT EXISTS sub_categories (
--   id INT PRIMARY KEY AUTO_INCREMENT,
--   main_category_id INT NOT NULL,
--   name VARCHAR(255) NOT NULL,
--   slug VARCHAR(255) NOT NULL,
--   description TEXT,
--   image VARCHAR(500),
--   status ENUM('active', 'inactive') DEFAULT 'active',
--   sort_order INT DEFAULT 0,
--   meta_title VARCHAR(255),
--   meta_description TEXT,
--   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--   FOREIGN KEY (main_category_id) REFERENCES categories(id) ON DELETE CASCADE,
--   INDEX idx_sub_categories_slug (slug),
--   INDEX idx_sub_categories_main (main_category_id),
--   INDEX idx_sub_categories_status (status)
-- ) ENGINE=InnoDB;

-- CREATE TABLE IF NOT EXISTS child_categories (
--   id INT PRIMARY KEY AUTO_INCREMENT,
--   sub_category_id INT NOT NULL,
--   name VARCHAR(255) NOT NULL,
--   slug VARCHAR(255) NOT NULL,
--   description TEXT,
--   image VARCHAR(500),
--   status ENUM('active', 'inactive') DEFAULT 'active',
--   sort_order INT DEFAULT 0,
--   meta_title VARCHAR(255),
--   meta_description TEXT,
--   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--   FOREIGN KEY (sub_category_id) REFERENCES sub_categories(id) ON DELETE CASCADE,
--   INDEX idx_child_categories_slug (slug),
--   INDEX idx_child_categories_sub (sub_category_id),
--   INDEX idx_child_categories_status (status)
-- ) ENGINE=InnoDB;

-- CREATE TABLE IF NOT EXISTS coupons (
--   id INT PRIMARY KEY AUTO_INCREMENT,
--   code VARCHAR(50) NOT NULL UNIQUE,
--   type ENUM('percentage', 'flat') NOT NULL,
--   value DECIMAL(10,2) NOT NULL,
--   minimum_order_amount DECIMAL(10,2) DEFAULT 0.00,
--   maximum_discount DECIMAL(10,2) DEFAULT 0.00,
--   usage_limit INT DEFAULT 0,
--   used_count INT DEFAULT 0,
--   per_user_limit INT DEFAULT 1,
--   is_for_new_customers TINYINT(1) DEFAULT 0,
--   start_date DATE,
--   expiry_date DATE NOT NULL,
--   status ENUM('active', 'inactive', 'expired') DEFAULT 'active',
--   description TEXT,
--   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--   INDEX idx_coupons_code (code),
--   INDEX idx_coupons_status (status),
--   INDEX idx_coupons_expiry (expiry_date)
-- ) ENGINE=InnoDB;

-- CREATE TABLE IF NOT EXISTS banners (
--   id INT PRIMARY KEY AUTO_INCREMENT,
--   title VARCHAR(255),
--   subtitle VARCHAR(500),
--   description TEXT,
--   image VARCHAR(500) NOT NULL,
--   mobile_image VARCHAR(500),
--   type ENUM('homepage', 'slider', 'mobile', 'promotional', 'popup') DEFAULT 'homepage',
--   position VARCHAR(50),
--   link VARCHAR(500),
--   button_text VARCHAR(100),
--   button_link VARCHAR(500),
--   sort_order INT DEFAULT 0,
--   priority INT DEFAULT 0,
--   start_date DATE,
--   end_date DATE,
--   status ENUM('active', 'inactive') DEFAULT 'active',
--   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--   INDEX idx_banners_type (type),
--   INDEX idx_banners_status (status),
--   INDEX idx_banners_position (position)
-- ) ENGINE=InnoDB;
