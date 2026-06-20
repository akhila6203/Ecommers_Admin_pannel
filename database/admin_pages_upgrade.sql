-- Run this file in phpMyAdmin to remove unused columns from existing lms database
-- Based on LM Admin Panel frontend (Gallery, Offers, Categories pages)

USE lms;

-- BANNERS: keep only title + image
ALTER TABLE banners DROP COLUMN subtitle;
ALTER TABLE banners DROP COLUMN description;
ALTER TABLE banners DROP COLUMN mobile_image;
ALTER TABLE banners DROP COLUMN type;
ALTER TABLE banners DROP COLUMN position;
ALTER TABLE banners DROP COLUMN link;
ALTER TABLE banners DROP COLUMN button_text;
ALTER TABLE banners DROP COLUMN button_link;
ALTER TABLE banners DROP COLUMN sort_order;
ALTER TABLE banners DROP COLUMN priority;
ALTER TABLE banners DROP COLUMN start_date;
ALTER TABLE banners DROP COLUMN end_date;
ALTER TABLE banners DROP COLUMN status;

-- COUPONS: keep only fields shown in Offers page
ALTER TABLE coupons DROP COLUMN minimum_order_amount;
ALTER TABLE coupons DROP COLUMN maximum_discount;
ALTER TABLE coupons DROP COLUMN usage_limit;
ALTER TABLE coupons DROP COLUMN used_count;
ALTER TABLE coupons DROP COLUMN per_user_limit;
ALTER TABLE coupons DROP COLUMN is_for_new_customers;
ALTER TABLE coupons DROP COLUMN description;
ALTER TABLE coupons MODIFY expiry_date DATE NULL;

-- MAIN CATEGORIES: keep only name (slug auto from backend)
ALTER TABLE categories DROP COLUMN description;
ALTER TABLE categories DROP COLUMN image;
ALTER TABLE categories DROP COLUMN icon;
ALTER TABLE categories DROP COLUMN status;
ALTER TABLE categories DROP COLUMN sort_order;
ALTER TABLE categories DROP COLUMN meta_title;
ALTER TABLE categories DROP COLUMN meta_description;

-- SUB CATEGORIES
ALTER TABLE sub_categories DROP COLUMN description;
ALTER TABLE sub_categories DROP COLUMN image;
ALTER TABLE sub_categories DROP COLUMN status;
ALTER TABLE sub_categories DROP COLUMN sort_order;
ALTER TABLE sub_categories DROP COLUMN meta_title;
ALTER TABLE sub_categories DROP COLUMN meta_description;

-- CHILD CATEGORIES
ALTER TABLE child_categories DROP COLUMN description;
ALTER TABLE child_categories DROP COLUMN image;
ALTER TABLE child_categories DROP COLUMN status;
ALTER TABLE child_categories DROP COLUMN sort_order;
ALTER TABLE child_categories DROP COLUMN meta_title;
ALTER TABLE child_categories DROP COLUMN meta_description;

-- Soft delete columns (if still present)
ALTER TABLE banners DROP COLUMN deleted_at;
ALTER TABLE coupons DROP COLUMN deleted_at;
ALTER TABLE categories DROP COLUMN deleted_at;
ALTER TABLE sub_categories DROP COLUMN deleted_at;
ALTER TABLE child_categories DROP COLUMN deleted_at;
