-- ============================================================
-- Fix product_variants schema (option_values column missing in old DB)
-- ============================================================

USE lms;

ALTER TABLE product_variants
  ADD COLUMN IF NOT EXISTS option_values longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL;
