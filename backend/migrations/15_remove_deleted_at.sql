-- ============================================================
-- Remove soft-delete columns (hard delete only)
-- Tables: categories, sub_categories, child_categories,
--         collections, banners, coupons, customers, orders
-- Keeps deleted_at on roles & admins only
-- ============================================================

USE lms;

-- orders: fix index that included deleted_at
ALTER TABLE orders DROP INDEX IF EXISTS idx_orders_status_created;
ALTER TABLE orders ADD INDEX IF NOT EXISTS idx_orders_status_created (order_status, created_at);

ALTER TABLE categories DROP COLUMN IF EXISTS deleted_at;
ALTER TABLE sub_categories DROP COLUMN IF EXISTS deleted_at;
ALTER TABLE child_categories DROP COLUMN IF EXISTS deleted_at;
ALTER TABLE collections DROP COLUMN IF EXISTS deleted_at;
ALTER TABLE banners DROP COLUMN IF EXISTS deleted_at;
ALTER TABLE coupons DROP COLUMN IF EXISTS deleted_at;
ALTER TABLE customers DROP COLUMN IF EXISTS deleted_at;
ALTER TABLE orders DROP COLUMN IF EXISTS deleted_at;
