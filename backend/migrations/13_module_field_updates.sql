-- ============================================================
-- LM Shopping Mall - Module field updates
-- Banners, Categories, Collections
-- ============================================================

USE lms;

-- Banners: text/CTA fields (subtitle1 is new; others may already exist)
ALTER TABLE banners ADD COLUMN IF NOT EXISTS title VARCHAR(255) DEFAULT '';
ALTER TABLE banners ADD COLUMN IF NOT EXISTS subtitle VARCHAR(255) DEFAULT '';
ALTER TABLE banners ADD COLUMN IF NOT EXISTS subtitle1 VARCHAR(255) DEFAULT '';
ALTER TABLE banners ADD COLUMN IF NOT EXISTS description TEXT NULL;
ALTER TABLE banners ADD COLUMN IF NOT EXISTS button_text VARCHAR(100) DEFAULT '';
ALTER TABLE banners ADD COLUMN IF NOT EXISTS button_link VARCHAR(500) DEFAULT '';

-- Categories: image paths (image column may already exist from base schema)
ALTER TABLE categories ADD COLUMN IF NOT EXISTS image_url LONGTEXT NULL;
ALTER TABLE sub_categories ADD COLUMN IF NOT EXISTS image_url LONGTEXT NULL;
ALTER TABLE child_categories ADD COLUMN IF NOT EXISTS image_url LONGTEXT NULL;

-- Collections: display label
ALTER TABLE collections ADD COLUMN IF NOT EXISTS label VARCHAR(255) DEFAULT '';
