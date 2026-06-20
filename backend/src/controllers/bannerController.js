import { query } from "../config/db.js";
import { successResponse, errorResponse, paginatedResponse } from "../helpers/responseHelper.js";
import { normalizeBannerImage } from "../helpers/imagePathHelper.js";
import logger from "../config/logger.js";

export const getBanners = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 50;
    const offset = (page - 1) * limit;

    const countResult = await query("SELECT COUNT(*) as total FROM banners");
    const total = countResult[0].total;
    const banners = await query(
      "SELECT id, title, image, created_at, updated_at FROM banners ORDER BY id DESC LIMIT ? OFFSET ?",
      [String(limit), String(offset)]
    );
    return paginatedResponse(res, banners.map(normalizeBannerImage), total, page, limit);
  } catch (error) {
    logger.error("Get banners error:", error);
    return errorResponse(res, "Failed to fetch banners", 500);
  }
};

export const getBanner = async (req, res) => {
  try {
    const banners = await query(
      "SELECT id, title, image, created_at, updated_at FROM banners WHERE id = ?",
      [req.params.id]
    );
    if (!banners.length) return errorResponse(res, "Banner not found", 404);
    return successResponse(res, normalizeBannerImage(banners[0]));
  } catch (error) {
    logger.error("Get banner error:", error);
    return errorResponse(res, "Failed to fetch banner", 500);
  }
};

export const createBanner = async (req, res) => {
  try {
    const { title } = req.body;
    const image = req.file ? `uploads/banners/${req.file.filename}` : req.body.image;

    if (!title || !title.trim()) return errorResponse(res, "Banner title is required", 400);
    if (!image) return errorResponse(res, "Banner image is required", 400);

    const result = await query(
      "INSERT INTO banners (title, image) VALUES (?, ?)",
      [title.trim(), image]
    );
    const banner = await query(
      "SELECT id, title, image, created_at, updated_at FROM banners WHERE id = ?",
      [result.insertId]
    );
    return successResponse(res, banner[0], "Banner created successfully", 201);
  } catch (error) {
    logger.error("Create banner error:", error);
    return errorResponse(res, "Failed to create banner", 500);
  }
};

export const updateBanner = async (req, res) => {
  try {
    const { title } = req.body;
    const existing = await query("SELECT id, title, image FROM banners WHERE id = ?", [req.params.id]);
    if (!existing.length) return errorResponse(res, "Banner not found", 404);

    const image = req.file ? `uploads/banners/${req.file.filename}` : existing[0].image;
    const nextTitle = title !== undefined && title !== null ? title.trim() : existing[0].title;

    await query(
      "UPDATE banners SET title = ?, image = ? WHERE id = ?",
      [nextTitle, image, req.params.id]
    );
    return successResponse(res, null, "Banner updated successfully");
  } catch (error) {
    logger.error("Update banner error:", error);
    return errorResponse(res, "Failed to update banner", 500);
  }
};

export const deleteBanner = async (req, res) => {
  try {
    const existing = await query("SELECT id FROM banners WHERE id = ?", [req.params.id]);
    if (!existing.length) return errorResponse(res, "Banner not found", 404);

    await query("DELETE FROM banners WHERE id = ?", [req.params.id]);
    return successResponse(res, null, "Banner deleted");
  } catch (error) {
    logger.error("Delete banner error:", error);
    return errorResponse(res, "Failed to delete banner", 500);
  }
};
