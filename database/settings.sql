-- ============================================================
-- Store & admin settings schema
-- Database: lms
-- No soft delete — permanent DELETE only
-- ============================================================

USE lms;

-- ============================================================
-- STORE SETTINGS (single-row table — primary source for Store Information)
-- ============================================================

CREATE TABLE IF NOT EXISTS store_settings (
  id INT PRIMARY KEY AUTO_INCREMENT,
  company_name VARCHAR(255) DEFAULT '',
  contact_email VARCHAR(255) DEFAULT '',
  website_url VARCHAR(500) DEFAULT '',
  gstin VARCHAR(20) DEFAULT '',
  pan VARCHAR(20) DEFAULT '',
  cin VARCHAR(30) DEFAULT '',
  gst_state_code VARCHAR(10) DEFAULT '',
  gst_registration_type VARCHAR(50) DEFAULT 'Regular',
  facebook_url VARCHAR(500) DEFAULT '',
  instagram_url VARCHAR(500) DEFAULT '',
  linkedin_url VARCHAR(500) DEFAULT '',
  youtube_url VARCHAR(500) DEFAULT '',
  whatsapp_number VARCHAR(30) DEFAULT '',
  whatsapp_message TEXT,
  store_address TEXT,
  city VARCHAR(100) DEFAULT '',
  state VARCHAR(100) DEFAULT '',
  country VARCHAR(100) DEFAULT '',
  postal_code VARCHAR(20) DEFAULT '',
  store_logo VARCHAR(500) DEFAULT '',
  store_banner VARCHAR(500) DEFAULT '',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO store_settings (id, company_name)
SELECT 1, ''
WHERE NOT EXISTS (SELECT 1 FROM store_settings WHERE id = 1);

-- ============================================================
-- INTEGRATION SETTINGS (single-row table — primary source for Integrations tab)
-- ============================================================

CREATE TABLE IF NOT EXISTS integration_settings (
  id INT PRIMARY KEY AUTO_INCREMENT,
  razorpay_enabled TINYINT(1) DEFAULT 0,
  razorpay_key_id VARCHAR(255) DEFAULT '',
  razorpay_key_secret VARCHAR(255) DEFAULT '',
  whatsapp_enabled TINYINT(1) DEFAULT 0,
  whatsapp_api_key VARCHAR(500) DEFAULT '',
  whatsapp_phone_number VARCHAR(50) DEFAULT '',
  shiprocket_enabled TINYINT(1) DEFAULT 0,
  shiprocket_email VARCHAR(255) DEFAULT '',
  shiprocket_password VARCHAR(255) DEFAULT '',
  shiprocket_channel_id VARCHAR(100) DEFAULT '',
  refund_enabled TINYINT(1) DEFAULT 0,
  refund_auto TINYINT(1) DEFAULT 0,
  refund_days INT DEFAULT 7,
  smtp_host VARCHAR(255) DEFAULT '',
  smtp_port VARCHAR(10) DEFAULT '',
  smtp_username VARCHAR(255) DEFAULT '',
  smtp_password VARCHAR(255) DEFAULT '',
  sender_email VARCHAR(255) DEFAULT '',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO integration_settings (id)
SELECT 1
WHERE NOT EXISTS (SELECT 1 FROM integration_settings WHERE id = 1);

-- ============================================================
-- LEGACY SETTINGS TABLE (admin UI prefs & content pages only)
-- Store Information and Integrations no longer save here.
-- ============================================================

CREATE TABLE IF NOT EXISTS settings (
  id INT PRIMARY KEY AUTO_INCREMENT,
  group_name VARCHAR(100) NOT NULL,
  key_name VARCHAR(100) NOT NULL,
  value LONGTEXT,
  type ENUM('text', 'number', 'boolean', 'json', 'image', 'email') DEFAULT 'text',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY unique_setting (group_name, key_name),
  INDEX idx_settings_group (group_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- UPGRADE: migrate key-value store_information into store_settings
-- Run once on existing databases (safe to re-run)
-- ============================================================

INSERT INTO store_settings (
  id, company_name, contact_email, website_url, gstin, pan, cin,
  gst_state_code, gst_registration_type, facebook_url, instagram_url,
  linkedin_url, youtube_url, whatsapp_number, whatsapp_message,
  store_address, city, state, country, postal_code, store_logo, store_banner
)
SELECT
  1,
  COALESCE(MAX(CASE WHEN key_name = 'companyName' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'contactEmail' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'websiteUrl' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'gstin' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'pan' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'cin' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'gstStateCode' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'gstRegistrationType' THEN value END), 'Regular'),
  COALESCE(MAX(CASE WHEN key_name = 'facebookUrl' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'instagramUrl' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'linkedinUrl' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'youtubeUrl' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'whatsappNumber' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'whatsappMessage' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'storeAddress' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'city' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'state' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'country' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'postalCode' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'storeLogo' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'storeBanner' THEN value END), '')
FROM settings
WHERE group_name = 'store_information'
HAVING COUNT(*) > 0
ON DUPLICATE KEY UPDATE
  company_name = IF(store_settings.company_name = '', VALUES(company_name), store_settings.company_name),
  contact_email = IF(store_settings.contact_email = '', VALUES(contact_email), store_settings.contact_email),
  website_url = IF(store_settings.website_url = '', VALUES(website_url), store_settings.website_url),
  gstin = IF(store_settings.gstin = '', VALUES(gstin), store_settings.gstin),
  pan = IF(store_settings.pan = '', VALUES(pan), store_settings.pan),
  cin = IF(store_settings.cin = '', VALUES(cin), store_settings.cin),
  gst_state_code = IF(store_settings.gst_state_code = '', VALUES(gst_state_code), store_settings.gst_state_code),
  gst_registration_type = IF(store_settings.gst_registration_type = 'Regular' AND VALUES(gst_registration_type) != 'Regular', VALUES(gst_registration_type), store_settings.gst_registration_type),
  facebook_url = IF(store_settings.facebook_url = '', VALUES(facebook_url), store_settings.facebook_url),
  instagram_url = IF(store_settings.instagram_url = '', VALUES(instagram_url), store_settings.instagram_url),
  linkedin_url = IF(store_settings.linkedin_url = '', VALUES(linkedin_url), store_settings.linkedin_url),
  youtube_url = IF(store_settings.youtube_url = '', VALUES(youtube_url), store_settings.youtube_url),
  whatsapp_number = IF(store_settings.whatsapp_number = '', VALUES(whatsapp_number), store_settings.whatsapp_number),
  whatsapp_message = IF(store_settings.whatsapp_message IS NULL OR store_settings.whatsapp_message = '', VALUES(whatsapp_message), store_settings.whatsapp_message),
  store_address = IF(store_settings.store_address IS NULL OR store_settings.store_address = '', VALUES(store_address), store_settings.store_address),
  city = IF(store_settings.city = '', VALUES(city), store_settings.city),
  state = IF(store_settings.state = '', VALUES(state), store_settings.state),
  country = IF(store_settings.country = '', VALUES(country), store_settings.country),
  postal_code = IF(store_settings.postal_code = '', VALUES(postal_code), store_settings.postal_code),
  store_logo = IF(store_settings.store_logo = '', VALUES(store_logo), store_settings.store_logo),
  store_banner = IF(store_settings.store_banner = '', VALUES(store_banner), store_settings.store_banner);

-- ============================================================
-- UPGRADE: migrate key-value integrations into integration_settings
-- Run once on existing databases (safe to re-run)
-- ============================================================

INSERT INTO integration_settings (
  id,
  razorpay_enabled, razorpay_key_id, razorpay_key_secret,
  whatsapp_enabled, whatsapp_api_key, whatsapp_phone_number,
  shiprocket_enabled, shiprocket_email, shiprocket_password, shiprocket_channel_id,
  refund_enabled, refund_auto, refund_days,
  smtp_host, smtp_port, smtp_username, smtp_password, sender_email
)
SELECT
  1,
  COALESCE(MAX(CASE WHEN key_name = 'razorpay_enabled' THEN value IN ('true', '1', 'TRUE') END), 0),
  COALESCE(MAX(CASE WHEN key_name = 'razorpay_key_id' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'razorpay_key_secret' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'whatsapp_enabled' THEN value IN ('true', '1', 'TRUE') END), 0),
  COALESCE(MAX(CASE WHEN key_name = 'whatsapp_api_key' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'whatsapp_phone_number' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'shiprocket_enabled' THEN value IN ('true', '1', 'TRUE') END), 0),
  COALESCE(MAX(CASE WHEN key_name = 'shiprocket_email' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'shiprocket_password' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'shiprocket_channel_id' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'refund_enabled' THEN value IN ('true', '1', 'TRUE') END), 0),
  COALESCE(MAX(CASE WHEN key_name = 'refund_auto' THEN value IN ('true', '1', 'TRUE') END), 0),
  COALESCE(MAX(CASE WHEN key_name = 'refund_days' THEN CAST(value AS UNSIGNED) END), 7),
  COALESCE(MAX(CASE WHEN key_name = 'smtp_host' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'smtp_port' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'smtp_username' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'smtp_password' THEN value END), ''),
  COALESCE(MAX(CASE WHEN key_name = 'sender_email' THEN value END), '')
FROM settings
WHERE group_name = 'integrations'
HAVING COUNT(*) > 0
ON DUPLICATE KEY UPDATE
  razorpay_enabled = IF(integration_settings.razorpay_key_id = '' AND VALUES(razorpay_key_id) != '', VALUES(razorpay_enabled), integration_settings.razorpay_enabled),
  razorpay_key_id = IF(integration_settings.razorpay_key_id = '', VALUES(razorpay_key_id), integration_settings.razorpay_key_id),
  razorpay_key_secret = IF(integration_settings.razorpay_key_secret = '', VALUES(razorpay_key_secret), integration_settings.razorpay_key_secret),
  whatsapp_enabled = IF(integration_settings.whatsapp_api_key = '' AND VALUES(whatsapp_api_key) != '', VALUES(whatsapp_enabled), integration_settings.whatsapp_enabled),
  whatsapp_api_key = IF(integration_settings.whatsapp_api_key = '', VALUES(whatsapp_api_key), integration_settings.whatsapp_api_key),
  whatsapp_phone_number = IF(integration_settings.whatsapp_phone_number = '', VALUES(whatsapp_phone_number), integration_settings.whatsapp_phone_number),
  shiprocket_enabled = IF(integration_settings.shiprocket_email = '' AND VALUES(shiprocket_email) != '', VALUES(shiprocket_enabled), integration_settings.shiprocket_enabled),
  shiprocket_email = IF(integration_settings.shiprocket_email = '', VALUES(shiprocket_email), integration_settings.shiprocket_email),
  shiprocket_password = IF(integration_settings.shiprocket_password = '', VALUES(shiprocket_password), integration_settings.shiprocket_password),
  shiprocket_channel_id = IF(integration_settings.shiprocket_channel_id = '', VALUES(shiprocket_channel_id), integration_settings.shiprocket_channel_id),
  refund_enabled = integration_settings.refund_enabled,
  refund_auto = integration_settings.refund_auto,
  refund_days = IF(integration_settings.refund_days = 7 AND VALUES(refund_days) != 7, VALUES(refund_days), integration_settings.refund_days),
  smtp_host = IF(integration_settings.smtp_host = '', VALUES(smtp_host), integration_settings.smtp_host),
  smtp_port = IF(integration_settings.smtp_port = '', VALUES(smtp_port), integration_settings.smtp_port),
  smtp_username = IF(integration_settings.smtp_username = '', VALUES(smtp_username), integration_settings.smtp_username),
  smtp_password = IF(integration_settings.smtp_password = '', VALUES(smtp_password), integration_settings.smtp_password),
  sender_email = IF(integration_settings.sender_email = '', VALUES(sender_email), integration_settings.sender_email);

-- Admin password/security uses existing admins table (no schema change required).
-- Password updates go through POST /api/auth/change-password.
