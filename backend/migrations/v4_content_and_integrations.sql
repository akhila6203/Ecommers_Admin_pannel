CREATE TABLE IF NOT EXISTS content_pages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  page_key VARCHAR(50) NOT NULL UNIQUE,
  title VARCHAR(255),
  content LONGTEXT,
  image VARCHAR(500),
  status ENUM('active','inactive') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS settings_integrations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  setting_key VARCHAR(100) NOT NULL UNIQUE,
  setting_value TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Normalize legacy banner image paths (bare filenames without uploads/ prefix)
UPDATE banners
SET image = CONCAT('uploads/banners/', image)
WHERE image IS NOT NULL
  AND image NOT LIKE 'uploads/%'
  AND image NOT LIKE 'http%';

-- Seed default content pages if missing
INSERT IGNORE INTO content_pages (page_key, title, content, status) VALUES
  ('about', 'About Us', '', 'active'),
  ('contact', 'Contact Us', '{}', 'active'),
  ('privacy-policy', 'Privacy Policy', '', 'active'),
  ('terms-conditions', 'Terms & Conditions', '', 'active'),
  ('shipping-policy', 'Shipping Policy', '', 'active'),
  ('refund-policy', 'Refund Policy', '', 'active');
