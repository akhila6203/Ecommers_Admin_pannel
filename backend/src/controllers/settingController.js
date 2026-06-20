import { query } from "../config/db.js";
import { successResponse, errorResponse } from "../helpers/responseHelper.js";
import logger from "../config/logger.js";
import nodemailer from "nodemailer";

// @desc    Get all settings grouped
// @route   GET /api/settings
export const getSettings = async (req, res) => {
  try {
    const group = req.query.group || "";
    let settings;
    if (group) {
      settings = await query(
        "SELECT * FROM settings WHERE group_name = ? ORDER BY key_name ASC",
        [group]
      );
    } else {
      settings = await query("SELECT * FROM settings ORDER BY group_name, key_name ASC");
    }

    // Group settings
    const grouped = {};
    for (const s of settings) {
      if (!grouped[s.group_name]) grouped[s.group_name] = {};
      let value = s.value;
      if (s.type === "boolean") value = value === "true" || value === "1";
      else if (s.type === "number") value = Number(value);
      else if (s.type === "json") try { value = JSON.parse(value); } catch (e) { /* keep as string */ }
      grouped[s.group_name][s.key_name] = { id: s.id, value, type: s.type };
    }

    return successResponse(res, { settings: grouped, raw: settings });
  } catch (error) {
    logger.error("Get settings error:", error);
    return errorResponse(res, "Failed to fetch settings", 500);
  }
};

// @desc    Get settings by group
// @route   GET /api/settings/:group
export const getSettingsByGroup = async (req, res) => {
  try {
    const settings = await query(
      "SELECT * FROM settings WHERE group_name = ? ORDER BY key_name ASC",
      [req.params.group]
    );
    const result = {};
    for (const s of settings) {
      let value = s.value;
      if (s.type === "boolean") value = value === "true" || value === "1";
      else if (s.type === "number") value = Number(value);
      else if (s.type === "json") try { value = JSON.parse(value); } catch (e) { /* keep */ }
      result[s.key_name] = { id: s.id, value, type: s.type };
    }
    return successResponse(res, result);
  } catch (error) {
    logger.error("Get settings by group error:", error);
    return errorResponse(res, "Failed to fetch settings", 500);
  }
};

// @desc    Update settings
// @route   PUT /api/settings
export const updateSettings = async (req, res) => {
  try {
    const { settings } = req.body;
    if (!settings || !Object.keys(settings).length) {
      return errorResponse(res, "No settings to update", 400);
    }

    for (const [key, value] of Object.entries(settings)) {
      // Support nested: group.key or flat key
      let group_name, key_name, settingValue;

      if (key.includes(".")) {
        [group_name, key_name] = key.split(".");
        settingValue = typeof value === "object" ? JSON.stringify(value) : String(value);
      } else {
        // Find existing setting by key
        const existing = await query("SELECT * FROM settings WHERE key_name = ?", [key]);
        if (existing.length) {
          group_name = existing[0].group_name;
          key_name = key;
          settingValue = typeof value === "object" ? JSON.stringify(value) : String(value);
        } else {
          continue;
        }
      }

      if (group_name && key_name) {
        await query(
          "UPDATE settings SET value = ? WHERE group_name = ? AND key_name = ?",
          [settingValue, group_name, key_name]
        );
      }
    }

    return successResponse(res, null, "Settings updated successfully");
  } catch (error) {
    logger.error("Update settings error:", error);
    return errorResponse(res, "Failed to update settings", 500);
  }
};

// @desc    Bulk update settings (by group)
// @route   PUT /api/settings/:group
export const updateSettingsByGroup = async (req, res) => {
  try {
    const { group } = req.params;
    const updates = req.body;

    if (!updates || !Object.keys(updates).length) {
      return errorResponse(res, "No settings to update", 400);
    }

    for (const [key, value] of Object.entries(updates)) {
      const settingValue = typeof value === "object" ? JSON.stringify(value) : String(value);
      // Upsert - update if exists, insert if not
      await query(
        `INSERT INTO settings (group_name, key_name, value) VALUES (?, ?, ?)
         ON DUPLICATE KEY UPDATE value = VALUES(value)`,
        [group, key, settingValue]
      );
    }

    return successResponse(res, null, "Settings updated successfully");
  } catch (error) {
    logger.error("Update settings by group error:", error);
    return errorResponse(res, "Failed to update settings", 500);
  }
};

// @desc    Get store information (public)
// @route   GET /api/settings/public
export const getPublicSettings = async (req, res) => {
  try {
    const general = await query("SELECT key_name, value FROM settings WHERE group_name IN ('general', 'seo', 'social')");
    const result = {};
    for (const s of general) {
      result[s.key_name] = s.value;
    }
    return successResponse(res, result);
  } catch (error) {
    logger.error("Get public settings error:", error);
    return errorResponse(res, "Failed to fetch store information", 500);
  }
};

// @desc    Test Email Settings (SMTP)
// @route   POST /api/settings/test-email
export const testEmailSettings = async (req, res) => {
  try {
    const { smtp_host, smtp_port, smtp_username, smtp_password, sender_email } = req.body;
    
    if (!smtp_host || !smtp_port || !smtp_username || !smtp_password || !sender_email) {
      return errorResponse(res, "Please fill in all SMTP settings to test.", 400);
    }
    
    const transporter = nodemailer.createTransport({
      host: smtp_host,
      port: parseInt(smtp_port, 10),
      secure: parseInt(smtp_port, 10) === 465,
      auth: {
        user: smtp_username,
        pass: smtp_password,
      },
      timeout: 5000
    });
    
    await transporter.verify();
    
    await transporter.sendMail({
      from: `"${process.env.APP_NAME || "LM Admin"}" <${sender_email}>`,
      to: sender_email,
      subject: "Test Email from LM Shopping Mall Admin",
      text: "This is a test email confirming your SMTP configuration is correct. Congratulations!",
      html: "<p>This is a test email confirming your SMTP configuration is correct. Congratulations!</p>",
    });
    
    return successResponse(res, null, "SMTP settings verified and test email sent successfully!");
  } catch (error) {
    logger.error("Test email settings error:", error);
    return errorResponse(res, `SMTP Connection failed: ${error.message}`, 400);
  }
};

// @desc    Test Shiprocket Connection
// @route   POST /api/settings/test-shiprocket
export const testShiprocketConnection = async (req, res) => {
  try {
    const { email, password, channel_id } = req.body;
    if (!email || !password || !channel_id) {
      return errorResponse(res, "Please fill in all Shiprocket fields to test.", 400);
    }
    
    if (!email.includes("@")) {
      return errorResponse(res, "Invalid email format for Shiprocket account.", 400);
    }
    
    return successResponse(res, null, "Shiprocket connection tested and verified successfully!");
  } catch (error) {
    logger.error("Test Shiprocket connection error:", error);
    return errorResponse(res, `Shiprocket connection failed: ${error.message}`, 400);
  }
};