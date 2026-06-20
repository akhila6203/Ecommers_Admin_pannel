import { query } from "../config/db.js";
import { successResponse, errorResponse } from "../helpers/responseHelper.js";
import logger from "../config/logger.js";

const upsertSetting = async (groupName, key, value, type = "text") => {
  const settingValue =
    type === "json" || typeof value === "object"
      ? JSON.stringify(value)
      : String(value ?? "");
  await query(
    `INSERT INTO settings (group_name, key_name, value, type)
     VALUES (?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE value = VALUES(value), type = VALUES(type)`,
    [groupName, key, settingValue, type]
  );
};

const getGroupFlat = async (groupName, defaults = {}) => {
  const rows = await query(
    "SELECT key_name, value, type FROM settings WHERE group_name = ?",
    [groupName]
  );
  const result = { ...defaults };
  for (const row of rows) {
    let value = row.value;
    if (row.type === "json") {
      try {
        value = JSON.parse(row.value);
      } catch {
        value = row.value;
      }
    }
    result[row.key_name] = value ?? defaults[row.key_name] ?? "";
  }
  return result;
};

const saveGroupFlat = async (groupName, data, jsonKeys = []) => {
  for (const [key, value] of Object.entries(data)) {
    const type = jsonKeys.includes(key) ? "json" : "text";
    await upsertSetting(groupName, key, value, type);
  }
};

const STORE_DEFAULTS = {
  companyName: "",
  contactEmail: "",
  websiteUrl: "",
  gstin: "",
  pan: "",
  cin: "",
  gstStateCode: "",
  gstRegistrationType: "Regular",
  facebookUrl: "",
  instagramUrl: "",
  linkedinUrl: "",
  youtubeUrl: "",
  whatsappNumber: "",
  whatsappMessage: "",
  storeAddress: "",
  city: "",
  state: "",
  country: "",
  postalCode: "",
  storeLogo: "",
  storeBanner: "",
};

const STORE_DB_COLUMNS = {
  companyName: "company_name",
  contactEmail: "contact_email",
  websiteUrl: "website_url",
  gstin: "gstin",
  pan: "pan",
  cin: "cin",
  gstStateCode: "gst_state_code",
  gstRegistrationType: "gst_registration_type",
  facebookUrl: "facebook_url",
  instagramUrl: "instagram_url",
  linkedinUrl: "linkedin_url",
  youtubeUrl: "youtube_url",
  whatsappNumber: "whatsapp_number",
  whatsappMessage: "whatsapp_message",
  storeAddress: "store_address",
  city: "city",
  state: "state",
  country: "country",
  postalCode: "postal_code",
  storeLogo: "store_logo",
  storeBanner: "store_banner",
};

const mapStoreRowToApi = (row = {}) => ({
  companyName: row.company_name || "",
  contactEmail: row.contact_email || "",
  websiteUrl: row.website_url || "",
  gstin: row.gstin || "",
  pan: row.pan || "",
  cin: row.cin || "",
  gstStateCode: row.gst_state_code || "",
  gstRegistrationType: row.gst_registration_type || "Regular",
  facebookUrl: row.facebook_url || "",
  instagramUrl: row.instagram_url || "",
  linkedinUrl: row.linkedin_url || "",
  youtubeUrl: row.youtube_url || "",
  whatsappNumber: row.whatsapp_number || "",
  whatsappMessage: row.whatsapp_message || "",
  storeAddress: row.store_address || "",
  city: row.city || "",
  state: row.state || "",
  country: row.country || "",
  postalCode: row.postal_code || "",
  storeLogo: row.store_logo || "",
  storeBanner: row.store_banner || "",
});

const ensureStoreSettingsRow = async () => {
  const rows = await query("SELECT id FROM store_settings WHERE id = 1");
  if (!rows.length) {
    await query("INSERT INTO store_settings (id) VALUES (1)");
  }
};

const getStoreSettingsRow = async () => {
  await ensureStoreSettingsRow();
  const rows = await query("SELECT * FROM store_settings WHERE id = 1 LIMIT 1");
  return rows[0] || {};
};

const saveStoreSettingsRow = async (data) => {
  await ensureStoreSettingsRow();
  const merged = { ...STORE_DEFAULTS, ...data };
  const columns = Object.entries(STORE_DB_COLUMNS);
  const sets = columns.map(([apiKey, dbCol]) => `${dbCol} = ?`);
  const values = columns.map(([apiKey]) => merged[apiKey] ?? "");
  await query(`UPDATE store_settings SET ${sets.join(", ")} WHERE id = 1`, values);
  return merged;
};

const PRIVACY_DEFAULTS = { title: "", content: "" };
const TERMS_DEFAULTS = { title: "", content: "" };
const CONTACT_DEFAULTS = {
  pageTitle: "",
  contactHeading: "",
  contactDescription: "",
  phoneNumber: "",
  emailAddress: "",
  address: "",
  googleMapsEmbedUrl: "",
  supportHours: "",
};

const defaultAboutSections = () => [
  {
    layout: "1-column",
    backgroundImage: "",
    columns: [
      {
        type: "text-btn",
        heading: "",
        content: "",
        buttonLabel: "",
        buttonLink: "",
      },
    ],
  },
];

const parseSections = (raw) => {
  if (!raw) return defaultAboutSections();
  try {
    const parsed = typeof raw === "string" ? JSON.parse(raw) : raw;
    return Array.isArray(parsed) && parsed.length ? parsed : defaultAboutSections();
  } catch {
    return defaultAboutSections();
  }
};

const isStoreDataEmpty = (data) =>
  !data.companyName &&
  !data.contactEmail &&
  !data.websiteUrl &&
  !data.storeLogo &&
  !data.storeAddress;

const migrateLegacyStore = async (result) => {
  if (isStoreDataEmpty(result)) {
    const legacyInfo = await getGroupFlat("store_information", {});
    if (!isStoreDataEmpty(legacyInfo)) {
      const migrated = { ...STORE_DEFAULTS, ...legacyInfo };
      try {
        await saveStoreSettingsRow(migrated);
      } catch (err) {
        logger.warn("Could not migrate store_information into store_settings:", err.message);
      }
      return migrated;
    }
  }

  const legacy = await getGroupFlat("store", {});
  if (!result.companyName && legacy.storeName) result.companyName = legacy.storeName;
  if (!result.contactEmail && legacy.email) result.contactEmail = legacy.email;
  if (!result.storeAddress && legacy.address) result.storeAddress = legacy.address;
  if (!result.storeLogo && legacy.logoUrl) result.storeLogo = legacy.logoUrl;
  if (!result.whatsappNumber && legacy.whatsapp) result.whatsappNumber = legacy.whatsapp;
  return result;
};

export const getStoreInformation = async (req, res) => {
  try {
    const row = await getStoreSettingsRow();
    let data = mapStoreRowToApi(row);
    data = await migrateLegacyStore(data);
    return successResponse(res, data);
  } catch (error) {
    logger.error("Get store information error:", error);
    return errorResponse(res, "Failed to fetch store information", 500);
  }
};

export const updateStoreInformation = async (req, res) => {
  try {
    const data = { ...STORE_DEFAULTS, ...req.body };
    const saved = await saveStoreSettingsRow(data);

    if (saved.storeLogo) await upsertSetting("store", "logoUrl", saved.storeLogo);
    if (saved.companyName) await upsertSetting("store", "storeName", saved.companyName);

    return successResponse(res, saved, "Store information saved successfully");
  } catch (error) {
    logger.error("Update store information error:", error);
    return errorResponse(res, "Failed to update store information", 500);
  }
};

const INTEGRATION_DEFAULTS = {
  razorpay_enabled: false,
  razorpay_key_id: "",
  razorpay_key_secret: "",
  whatsapp_enabled: false,
  whatsapp_api_key: "",
  whatsapp_phone_number: "",
  shiprocket_enabled: false,
  shiprocket_email: "",
  shiprocket_password: "",
  shiprocket_channel_id: "",
  refund_enabled: false,
  refund_auto: false,
  refund_days: 7,
  smtp_host: "",
  smtp_port: "",
  smtp_username: "",
  smtp_password: "",
  sender_email: "",
};

const INTEGRATION_DB_COLUMNS = {
  razorpay_enabled: "razorpay_enabled",
  razorpay_key_id: "razorpay_key_id",
  razorpay_key_secret: "razorpay_key_secret",
  whatsapp_enabled: "whatsapp_enabled",
  whatsapp_api_key: "whatsapp_api_key",
  whatsapp_phone_number: "whatsapp_phone_number",
  shiprocket_enabled: "shiprocket_enabled",
  shiprocket_email: "shiprocket_email",
  shiprocket_password: "shiprocket_password",
  shiprocket_channel_id: "shiprocket_channel_id",
  refund_enabled: "refund_enabled",
  refund_auto: "refund_auto",
  refund_days: "refund_days",
  smtp_host: "smtp_host",
  smtp_port: "smtp_port",
  smtp_username: "smtp_username",
  smtp_password: "smtp_password",
  sender_email: "sender_email",
};

const BOOL_INTEGRATION_KEYS = new Set([
  "razorpay_enabled",
  "whatsapp_enabled",
  "shiprocket_enabled",
  "refund_enabled",
  "refund_auto",
]);

const mapIntegrationRowToApi = (row = {}) => {
  const result = { ...INTEGRATION_DEFAULTS };
  for (const [apiKey, dbCol] of Object.entries(INTEGRATION_DB_COLUMNS)) {
    if (row[dbCol] === undefined || row[dbCol] === null) continue;
    if (BOOL_INTEGRATION_KEYS.has(apiKey)) {
      result[apiKey] = row[dbCol] === 1 || row[dbCol] === true || row[dbCol] === "1";
    } else if (apiKey === "refund_days") {
      result[apiKey] = Number(row[dbCol]) || 7;
    } else {
      result[apiKey] = String(row[dbCol] ?? "");
    }
  }
  return result;
};

const ensureIntegrationSettingsRow = async () => {
  const rows = await query("SELECT id FROM integration_settings WHERE id = 1");
  if (!rows.length) {
    await query("INSERT INTO integration_settings (id) VALUES (1)");
  }
};

const getIntegrationSettingsRow = async () => {
  await ensureIntegrationSettingsRow();
  const rows = await query("SELECT * FROM integration_settings WHERE id = 1 LIMIT 1");
  return rows[0] || {};
};

const saveIntegrationSettingsRow = async (data) => {
  await ensureIntegrationSettingsRow();
  const merged = { ...INTEGRATION_DEFAULTS, ...data };
  const columns = Object.entries(INTEGRATION_DB_COLUMNS);
  const sets = columns.map(([, dbCol]) => `${dbCol} = ?`);
  const values = columns.map(([apiKey]) => {
    if (BOOL_INTEGRATION_KEYS.has(apiKey)) {
      return merged[apiKey] === true || merged[apiKey] === "true" || merged[apiKey] === 1 || merged[apiKey] === "1" ? 1 : 0;
    }
    if (apiKey === "refund_days") {
      return Number.parseInt(String(merged[apiKey] ?? 7), 10) || 7;
    }
    return String(merged[apiKey] ?? "");
  });
  await query(`UPDATE integration_settings SET ${sets.join(", ")} WHERE id = 1`, values);
  return mapIntegrationRowToApi(
    Object.fromEntries(columns.map(([apiKey, dbCol], i) => [dbCol, values[i]]))
  );
};

const isIntegrationDataEmpty = (data) =>
  !data.razorpay_key_id &&
  !data.smtp_host &&
  !data.shiprocket_email &&
  !data.whatsapp_api_key;

const migrateLegacyIntegrations = async (result) => {
  if (!isIntegrationDataEmpty(result)) return result;

  const legacy = await getGroupFlat("integrations", {});
  if (isIntegrationDataEmpty(legacy)) return result;

  const migrated = { ...INTEGRATION_DEFAULTS };
  for (const key of Object.keys(INTEGRATION_DEFAULTS)) {
    const raw = legacy[key];
    if (raw === undefined || raw === null || raw === "") continue;
    if (BOOL_INTEGRATION_KEYS.has(key)) {
      migrated[key] = raw === true || raw === "true" || raw === 1 || raw === "1";
    } else if (key === "refund_days") {
      migrated[key] = Number.parseInt(String(raw), 10) || 7;
    } else {
      migrated[key] = String(raw);
    }
  }

  try {
    return await saveIntegrationSettingsRow(migrated);
  } catch (err) {
    logger.warn("Could not migrate integrations into integration_settings:", err.message);
    return migrated;
  }
};

export const getIntegrationSettings = async (req, res) => {
  try {
    const row = await getIntegrationSettingsRow();
    let data = mapIntegrationRowToApi(row);
    data = await migrateLegacyIntegrations(data);
    return successResponse(res, data);
  } catch (error) {
    logger.error("Get integration settings error:", error);
    return errorResponse(res, "Failed to fetch integration settings", 500);
  }
};

export const updateIntegrationSettings = async (req, res) => {
  try {
    const saved = await saveIntegrationSettingsRow({ ...INTEGRATION_DEFAULTS, ...req.body });
    return successResponse(res, saved, "Integration settings saved successfully");
  } catch (error) {
    logger.error("Update integration settings error:", error);
    return errorResponse(res, "Failed to update integration settings", 500);
  }
};

export const getAboutUsSettings = async (req, res) => {
  try {
    const rows = await query(
      "SELECT key_name, value FROM settings WHERE group_name = ?",
      ["about_us"]
    );
    const sectionsRow = rows.find((r) => r.key_name === "sections");
    const sections = sectionsRow?.value
      ? parseSections(sectionsRow.value)
      : defaultAboutSections();
    return successResponse(res, { sections });
  } catch (error) {
    logger.error("Get about us settings error:", error);
    return errorResponse(res, "Failed to fetch about us settings", 500);
  }
};

export const updateAboutUsSettings = async (req, res) => {
  try {
    const { sections } = req.body || {};
    if (!Array.isArray(sections)) {
      return errorResponse(res, "sections must be an array", 400);
    }
    const normalized = sections.map((row) => ({
      layout: row.layout || "1-column",
      backgroundImage: row.backgroundImage || "",
      columns: (row.columns || []).map((col) =>
        col.type === "image"
          ? { type: "image", image: col.image || "" }
          : {
              type: "text-btn",
              heading: col.heading || "",
              content: col.content || "",
              buttonLabel: col.buttonLabel || "",
              buttonLink: col.buttonLink || "",
            }
      ),
    }));
    await upsertSetting("about_us", "sections", normalized, "json");
    return successResponse(res, { sections: normalized }, "About us saved successfully");
  } catch (error) {
    logger.error("Update about us settings error:", error);
    return errorResponse(res, "Failed to update about us settings", 500);
  }
};

export const getPrivacyPolicy = async (req, res) => {
  try {
    let data = await getGroupFlat("privacy_policy", PRIVACY_DEFAULTS);
    if (!data.content) {
      const legacy = await getGroupFlat("privacy", {});
      if (legacy.privacyPolicy) data = { title: "Privacy Policy", content: legacy.privacyPolicy };
    }
    return successResponse(res, data);
  } catch (error) {
    logger.error("Get privacy policy error:", error);
    return errorResponse(res, "Failed to fetch privacy policy", 500);
  }
};

export const updatePrivacyPolicy = async (req, res) => {
  try {
    const data = { ...PRIVACY_DEFAULTS, ...req.body };
    await saveGroupFlat("privacy_policy", data);
    return successResponse(res, data, "Privacy policy saved successfully");
  } catch (error) {
    logger.error("Update privacy policy error:", error);
    return errorResponse(res, "Failed to update privacy policy", 500);
  }
};

export const getTermsConditions = async (req, res) => {
  try {
    let data = await getGroupFlat("terms_conditions", TERMS_DEFAULTS);
    if (!data.content) {
      const legacy = await getGroupFlat("terms", {});
      if (legacy.termsContent) data = { title: "Terms & Conditions", content: legacy.termsContent };
    }
    return successResponse(res, data);
  } catch (error) {
    logger.error("Get terms conditions error:", error);
    return errorResponse(res, "Failed to fetch terms & conditions", 500);
  }
};

export const updateTermsConditions = async (req, res) => {
  try {
    const data = { ...TERMS_DEFAULTS, ...req.body };
    await saveGroupFlat("terms_conditions", data);
    return successResponse(res, data, "Terms & conditions saved successfully");
  } catch (error) {
    logger.error("Update terms conditions error:", error);
    return errorResponse(res, "Failed to update terms & conditions", 500);
  }
};

export const getContactPage = async (req, res) => {
  try {
    let data = await getGroupFlat("contact_page", CONTACT_DEFAULTS);
    if (!data.contactDescription) {
      const legacyStore = await getGroupFlat("store", {});
      const legacyContact = await getGroupFlat("contact", {});
      if (legacyContact.contactPage) data.contactDescription = legacyContact.contactPage;
      if (legacyStore.supportEmail) data.emailAddress = legacyStore.supportEmail;
      if (legacyStore.whatsapp) data.phoneNumber = legacyStore.whatsapp;
      if (legacyStore.location) data.address = legacyStore.location;
      if (legacyStore.mapLocation) data.googleMapsEmbedUrl = legacyStore.mapLocation;
    }
    return successResponse(res, data);
  } catch (error) {
    logger.error("Get contact page error:", error);
    return errorResponse(res, "Failed to fetch contact page", 500);
  }
};

export const updateContactPage = async (req, res) => {
  try {
    const data = { ...CONTACT_DEFAULTS, ...req.body };
    await saveGroupFlat("contact_page", data);
    return successResponse(res, data, "Contact page saved successfully");
  } catch (error) {
    logger.error("Update contact page error:", error);
    return errorResponse(res, "Failed to update contact page", 500);
  }
};
