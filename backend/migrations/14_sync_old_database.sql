-- ============================================================
-- LM Shopping Mall - Sync old database to current migration schema
-- Adds store_id, missing columns, and composite unique keys
-- Safe to re-run (IF NOT EXISTS / IF EXISTS)
-- ============================================================

USE lms;

-- Ensure default store exists
INSERT INTO stores (id, name, slug, status)
VALUES (1, 'LM Shopping Mall', 'lm-shopping-mall', 'active')
ON DUPLICATE KEY UPDATE name = VALUES(name), slug = VALUES(slug), status = VALUES(status);

-- ------------------------------------------------------------
-- store_id on multi-tenant tables
-- ------------------------------------------------------------
ALTER TABLE categories ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE sub_categories ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE child_categories ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE products ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE product_images ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE product_variants ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE product_variant_options ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE product_seo ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE inventory ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE inventory_logs ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE collections ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE collection_products ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE customers ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE customer_addresses ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE cart ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE wishlists ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE reviews ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE order_items ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE order_timeline ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE order_notes ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE coupons ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE offers ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE banners ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE content_pages ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE settings ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE media ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;
ALTER TABLE notifications ADD COLUMN IF NOT EXISTS store_id int(11) NOT NULL DEFAULT 1 AFTER id;

UPDATE categories SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE sub_categories SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE child_categories SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE products SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE product_images SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE product_variants SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE product_variant_options SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE product_seo SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE inventory SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE inventory_logs SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE collections SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE collection_products SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE customers SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE customer_addresses SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE cart SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE wishlists SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE reviews SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE orders SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE order_items SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE order_timeline SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE order_notes SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE coupons SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE offers SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE banners SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE content_pages SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE settings SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE media SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;
UPDATE notifications SET store_id = 1 WHERE store_id IS NULL OR store_id = 0;

-- ------------------------------------------------------------
-- Auth: deleted_at (roles & admins only in migration schema)
-- ------------------------------------------------------------
ALTER TABLE roles ADD COLUMN IF NOT EXISTS deleted_at timestamp NULL DEFAULT NULL;
ALTER TABLE admins ADD COLUMN IF NOT EXISTS deleted_at timestamp NULL DEFAULT NULL;

-- ------------------------------------------------------------
-- Module field updates (also in 13_module_field_updates.sql)
-- ------------------------------------------------------------
ALTER TABLE banners ADD COLUMN IF NOT EXISTS title VARCHAR(255) DEFAULT '';
ALTER TABLE banners ADD COLUMN IF NOT EXISTS subtitle VARCHAR(255) DEFAULT '';
ALTER TABLE banners ADD COLUMN IF NOT EXISTS subtitle1 VARCHAR(255) DEFAULT '';
ALTER TABLE banners ADD COLUMN IF NOT EXISTS description TEXT NULL;
ALTER TABLE banners ADD COLUMN IF NOT EXISTS button_text VARCHAR(100) DEFAULT '';
ALTER TABLE banners ADD COLUMN IF NOT EXISTS button_link VARCHAR(500) DEFAULT '';

ALTER TABLE categories ADD COLUMN IF NOT EXISTS image_url LONGTEXT NULL;
ALTER TABLE sub_categories ADD COLUMN IF NOT EXISTS image_url LONGTEXT NULL;
ALTER TABLE child_categories ADD COLUMN IF NOT EXISTS image_url LONGTEXT NULL;

ALTER TABLE collections ADD COLUMN IF NOT EXISTS label VARCHAR(255) DEFAULT '';

ALTER TABLE products ADD COLUMN IF NOT EXISTS vendor VARCHAR(255) DEFAULT NULL;
ALTER TABLE products ADD COLUMN IF NOT EXISTS product_type VARCHAR(255) DEFAULT NULL;

-- product_variants: option_values (required by backend variant save/list)
ALTER TABLE product_variants ADD COLUMN IF NOT EXISTS option_values longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL;

-- coupon_usage: ensure discount_amount exists; migrate legacy coupon_usages data
ALTER TABLE coupon_usage ADD COLUMN IF NOT EXISTS discount_amount decimal(10,2) DEFAULT 0.00;

INSERT IGNORE INTO coupon_usage (store_id, coupon_id, customer_id, order_id, used_at)
SELECT 1, coupon_id, customer_id, order_id, used_at
FROM coupon_usages
WHERE EXISTS (SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'lms' AND TABLE_NAME = 'coupon_usages');

-- ------------------------------------------------------------
-- Composite unique keys (store-scoped slugs/codes)
-- ------------------------------------------------------------
ALTER TABLE categories DROP INDEX IF EXISTS slug;
ALTER TABLE categories ADD UNIQUE INDEX IF NOT EXISTS uq_categories_store_slug (store_id, slug);
ALTER TABLE categories ADD INDEX IF NOT EXISTS idx_categories_store_id (store_id);

ALTER TABLE sub_categories ADD INDEX IF NOT EXISTS idx_sub_categories_store_id (store_id);
ALTER TABLE child_categories ADD INDEX IF NOT EXISTS idx_child_categories_store_id (store_id);

ALTER TABLE products DROP INDEX IF EXISTS slug;
ALTER TABLE products DROP INDEX IF EXISTS sku;
ALTER TABLE products ADD UNIQUE INDEX IF NOT EXISTS uq_products_store_slug (store_id, slug);
ALTER TABLE products ADD UNIQUE INDEX IF NOT EXISTS uq_products_store_sku (store_id, sku);
ALTER TABLE products ADD INDEX IF NOT EXISTS idx_products_store_id (store_id);

ALTER TABLE product_images ADD INDEX IF NOT EXISTS idx_product_images_store_id (store_id);
ALTER TABLE product_variants ADD INDEX IF NOT EXISTS idx_product_variants_store_id (store_id);
ALTER TABLE product_variant_options ADD INDEX IF NOT EXISTS idx_product_variant_options_store_id (store_id);
ALTER TABLE product_seo ADD INDEX IF NOT EXISTS idx_product_seo_store_id (store_id);
ALTER TABLE inventory ADD INDEX IF NOT EXISTS idx_inventory_store_id (store_id);
ALTER TABLE inventory_logs ADD INDEX IF NOT EXISTS idx_inventory_logs_store_id (store_id);

ALTER TABLE collections DROP INDEX IF EXISTS slug;
ALTER TABLE collections ADD UNIQUE INDEX IF NOT EXISTS uq_collections_store_slug (store_id, slug);
ALTER TABLE collections ADD INDEX IF NOT EXISTS idx_collections_store_id (store_id);
ALTER TABLE collection_products ADD INDEX IF NOT EXISTS idx_collection_products_store_id (store_id);

ALTER TABLE customers DROP INDEX IF EXISTS email;
ALTER TABLE customers ADD UNIQUE INDEX IF NOT EXISTS uq_customers_store_email (store_id, email);
ALTER TABLE customers ADD INDEX IF NOT EXISTS idx_customers_store_id (store_id);

ALTER TABLE customer_addresses ADD INDEX IF NOT EXISTS idx_customer_addresses_store_id (store_id);
ALTER TABLE cart ADD INDEX IF NOT EXISTS idx_cart_store_id (store_id);
ALTER TABLE wishlists ADD INDEX IF NOT EXISTS idx_wishlists_store_id (store_id);
ALTER TABLE reviews ADD INDEX IF NOT EXISTS idx_reviews_store_id (store_id);

ALTER TABLE orders DROP INDEX IF EXISTS order_number;
ALTER TABLE orders ADD UNIQUE INDEX IF NOT EXISTS uq_orders_store_order_number (store_id, order_number);
ALTER TABLE orders ADD INDEX IF NOT EXISTS idx_orders_store_id (store_id);

ALTER TABLE order_items ADD INDEX IF NOT EXISTS idx_order_items_store_id (store_id);
ALTER TABLE order_timeline ADD INDEX IF NOT EXISTS idx_order_timeline_store_id (store_id);
ALTER TABLE order_notes ADD INDEX IF NOT EXISTS idx_order_notes_store_id (store_id);

ALTER TABLE coupons DROP INDEX IF EXISTS code;
ALTER TABLE coupons ADD UNIQUE INDEX IF NOT EXISTS uq_coupons_store_code (store_id, code);
ALTER TABLE coupons ADD INDEX IF NOT EXISTS idx_coupons_store_id (store_id);
ALTER TABLE coupon_usage ADD INDEX IF NOT EXISTS idx_coupon_usage_store_id (store_id);

ALTER TABLE offers DROP INDEX IF EXISTS slug;
ALTER TABLE offers ADD UNIQUE INDEX IF NOT EXISTS uq_offers_store_slug (store_id, slug);
ALTER TABLE offers ADD INDEX IF NOT EXISTS idx_offers_store_id (store_id);

ALTER TABLE banners ADD INDEX IF NOT EXISTS idx_banners_store_id (store_id);

ALTER TABLE content_pages DROP INDEX IF EXISTS page_key;
ALTER TABLE content_pages ADD UNIQUE INDEX IF NOT EXISTS uq_content_pages_store_key (store_id, page_key);
ALTER TABLE content_pages ADD INDEX IF NOT EXISTS idx_content_pages_store_id (store_id);

ALTER TABLE settings DROP INDEX IF EXISTS unique_setting;
ALTER TABLE settings ADD UNIQUE INDEX IF NOT EXISTS uq_settings_store_group_key (store_id, group_name, key_name);
ALTER TABLE settings ADD INDEX IF NOT EXISTS idx_settings_store_id (store_id);

ALTER TABLE media ADD INDEX IF NOT EXISTS idx_media_store_id (store_id);
ALTER TABLE notifications ADD INDEX IF NOT EXISTS idx_notifications_store_id (store_id);

-- Drop legacy table not in migration schema (data migrated to coupon_usage above)
DROP TABLE IF EXISTS coupon_usages;
