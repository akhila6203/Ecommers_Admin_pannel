import { query } from "../config/db.js";
import { successResponse, errorResponse, paginatedResponse } from "../helpers/responseHelper.js";
import logger from "../config/logger.js";

// @desc    Get all media
// @route   GET /api/media
export const getMedia = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 50;
    const offset = (page - 1) * limit;
    const folder = req.query.folder || "";
    const type = req.query.type || "";
    const search = req.query.search || "";

    let whereClause = "WHERE 1=1";
    const params = [];

    if (folder) { whereClause += " AND m.folder = ?"; params.push(folder); }
    if (type) { whereClause += " AND m.type = ?"; params.push(type); }
    if (search) { whereClause += " AND (m.original_name LIKE ? OR m.alt_text LIKE ?)"; params.push(`%${search}%`, `%${search}%`); }

    const countResult = await query(`SELECT COUNT(*) as total FROM media m ${whereClause}`, params);
    const total = countResult[0].total;

    const media = await query(
      `SELECT m.* FROM media m ${whereClause} ORDER BY m.created_at DESC LIMIT ? OFFSET ?`,
      [...params, String(limit), String(offset)]
    );

    // Get folder list
    const folders = await query("SELECT DISTINCT folder FROM media ORDER BY folder ASC");

    return paginatedResponse(res, media, total, page, limit, { folders: folders.map(f => f.folder) });
  } catch (error) {
    logger.error("Get media error:", error);
    return errorResponse(res, "Failed to fetch media", 500);
  }
};

// @desc    Upload media
// @route   POST /api/media/upload
export const uploadMedia = async (req, res) => {
  try {
    if (!req.file) return errorResponse(res, "No file uploaded", 400);

    const { folder, alt_text } = req.body;
    const file = req.file;

    const result = await query(
      "INSERT INTO media (filename, original_name, path, url, type, size, mime_type, folder, alt_text, uploaded_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
      [
        file.filename,
        file.originalname,
        file.path.replace(/\\/g, "/"),
        `uploads/media/${file.filename}`,
        file.mimetype.split("/")[0] || "other",
        file.size,
        file.mimetype,
        folder || "general",
        alt_text || file.originalname,
        req.admin?.id || null,
      ]
    );

    const media = await query("SELECT * FROM media WHERE id = ?", [result.insertId]);
    return successResponse(res, media[0], "File uploaded successfully", 201);
  } catch (error) {
    logger.error("Upload media error:", error);
    return errorResponse(res, "Failed to upload file", 500);
  }
};

// @desc    Upload multiple media
// @route   POST /api/media/upload-multiple
export const uploadMultipleMedia = async (req, res) => {
  try {
    if (!req.files || !req.files.length) return errorResponse(res, "No files uploaded", 400);

    const { folder } = req.body;
    const uploaded = [];

    for (const file of req.files) {
      const result = await query(
        "INSERT INTO media (filename, original_name, path, url, type, size, mime_type, folder, alt_text, uploaded_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        [
          file.filename,
          file.originalname,
          file.path.replace(/\\/g, "/"),
          `uploads/media/${file.filename}`,
          file.mimetype.split("/")[0] || "other",
          file.size,
          file.mimetype,
          folder || "general",
          file.originalname,
          req.admin?.id || null,
        ]
      );
      const media = await query("SELECT * FROM media WHERE id = ?", [result.insertId]);
      uploaded.push(media[0]);
    }

    return successResponse(res, uploaded, `${uploaded.length} files uploaded`, 201);
  } catch (error) {
    logger.error("Upload multiple error:", error);
    return errorResponse(res, "Failed to upload files", 500);
  }
};

// @desc    Update media info
// @route   PUT /api/media/:id
export const updateMedia = async (req, res) => {
  try {
    const { alt_text, folder } = req.body;
    const existing = await query("SELECT * FROM media WHERE id = ?", [req.params.id]);
    if (!existing.length) return errorResponse(res, "Media not found", 404);

    await query(
      "UPDATE media SET alt_text = COALESCE(?, alt_text), folder = COALESCE(?, folder) WHERE id = ?",
      [alt_text || null, folder || null, req.params.id]
    );
    return successResponse(res, null, "Media updated");
  } catch (error) {
    logger.error("Update media error:", error);
    return errorResponse(res, "Failed to update media", 500);
  }
};

// @desc    Delete media
// @route   DELETE /api/media/:id
export const deleteMedia = async (req, res) => {
  try {
    const existing = await query("SELECT * FROM media WHERE id = ?", [req.params.id]);
    if (!existing.length) return errorResponse(res, "Media not found", 404);
    await query("DELETE FROM media WHERE id = ?", [req.params.id]);
    return successResponse(res, null, "Media deleted");
  } catch (error) {
    logger.error("Delete media error:", error);
    return errorResponse(res, "Failed to delete media", 500);
  }
};

// @desc    Get folders
// @route   GET /api/media/folders
export const getMediaFolders = async (req, res) => {
  try {
    const folders = await query(
      "SELECT folder, COUNT(*) as file_count FROM media GROUP BY folder ORDER BY folder ASC"
    );
    return successResponse(res, folders);
  } catch (error) {
    logger.error("Get folders error:", error);
    return errorResponse(res, "Failed to fetch folders", 500);
  }
};