import { query } from "../config/db.js";
import { generateSlug } from "../helpers/slugHelper.js";
import { successResponse, errorResponse, paginatedResponse } from "../helpers/responseHelper.js";
import logger from "../config/logger.js";

const parseProductIds = (product_ids) => {
  if (!product_ids) return [];
  if (Array.isArray(product_ids)) {
    return product_ids.map((id) => parseInt(id, 10)).filter((id) => !Number.isNaN(id) && id > 0);
  }
  return [];
};

// @desc    Get all collections
// @route   GET /api/collections
export const getCollections = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const offset = (page - 1) * limit;
    const search = req.query.search || "";
    const status = req.query.status || "";

    let whereClause = "WHERE 1=1";
    const params = [];

    if (search) {
      whereClause += " AND (c.name LIKE ? OR c.description LIKE ?)";
      params.push(`%${search}%`, `%${search}%`);
    }
    if (status) {
      whereClause += " AND c.status = ?";
      params.push(status);
    }

    const countResult = await query(
      `SELECT COUNT(*) as total FROM collections c ${whereClause}`,
      params
    );
    const total = countResult[0].total;

    const collections = await query(
      `SELECT c.*,
        (SELECT COUNT(*) FROM collection_products WHERE collection_id = c.id) as product_count
       FROM collections c
       ${whereClause}
       ORDER BY c.sort_order ASC, c.created_at DESC
       LIMIT ? OFFSET ?`,
      [...params, String(limit), String(offset)]
    );

    return paginatedResponse(res, collections, total, page, limit);
  } catch (error) {
    logger.error("Get collections error:", error);
    return errorResponse(res, "Failed to fetch collections", 500);
  }
};

// @desc    Get single collection
// @route   GET /api/collections/:id
export const getCollection = async (req, res) => {
  try {
    const collections = await query(
      "SELECT * FROM collections WHERE id = ?",
      [req.params.id]
    );
    if (!collections.length) return errorResponse(res, "Collection not found", 404);

    const collection = collections[0];
    collection.products = await query(
      `SELECT cp.sort_order, p.id, p.name, p.slug, p.price, p.offer_price, p.thumbnail, p.stock, p.stock_status, p.status
       FROM collection_products cp
       JOIN products p ON cp.product_id = p.id
       WHERE cp.collection_id = ?
       ORDER BY cp.sort_order ASC`,
      [collection.id]
    );

    return successResponse(res, collection);
  } catch (error) {
    logger.error("Get collection error:", error);
    return errorResponse(res, "Failed to fetch collection", 500);
  }
};

// @desc    Create collection
// @route   POST /api/collections
export const createCollection = async (req, res) => {
  try {
    const { name, description, type, sort_order, status, meta_title, meta_description, product_ids } = req.body;
    if (!name?.trim()) return errorResponse(res, "Collection name is required", 400);

    const slug = generateSlug(name);
    const existing = await query("SELECT id FROM collections WHERE slug = ?", [slug]);
    const finalSlug = existing.length ? `${slug}-${Date.now()}` : slug;

    const image = req.files?.image ? `uploads/collections/${req.files.image[0].filename}` : null;
    const banner = req.files?.banner ? `uploads/collections/${req.files.banner[0].filename}` : null;

    const result = await query(
      `INSERT INTO collections (name, slug, description, image, banner, type, sort_order, status, meta_title, meta_description)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        name.trim(),
        finalSlug,
        description || null,
        image,
        banner,
        type || null,
        sort_order !== undefined ? parseInt(sort_order, 10) || 0 : 0,
        status || "active",
        meta_title || null,
        meta_description || null,
      ]
    );

    const ids = parseProductIds(product_ids);
    if (ids.length) {
      for (let i = 0; i < ids.length; i++) {
        await query(
          "INSERT INTO collection_products (collection_id, product_id, sort_order) VALUES (?, ?, ?)",
          [result.insertId, ids[i], i]
        );
      }
    }

    const collection = await query("SELECT * FROM collections WHERE id = ?", [result.insertId]);
    return successResponse(res, collection[0], "Collection created successfully", 201);
  } catch (error) {
    logger.error("Create collection error:", error);
    return errorResponse(res, "Failed to create collection", 500);
  }
};

// @desc    Update collection
// @route   PUT /api/collections/:id
export const updateCollection = async (req, res) => {
  try {
    const existing = await query("SELECT * FROM collections WHERE id = ?", [req.params.id]);
    if (!existing.length) return errorResponse(res, "Collection not found", 404);

    const { name, description, type, sort_order, status, meta_title, meta_description, product_ids } = req.body;

    let slug = existing[0].slug;
    if (name?.trim() && name.trim() !== existing[0].name) {
      const baseSlug = generateSlug(name);
      const slugCheck = await query("SELECT id FROM collections WHERE slug = ? AND id != ?", [baseSlug, req.params.id]);
      slug = slugCheck.length ? `${baseSlug}-${Date.now()}` : baseSlug;
    }

    const image = req.files?.image ? `uploads/collections/${req.files.image[0].filename}` : existing[0].image;
    const banner = req.files?.banner ? `uploads/collections/${req.files.banner[0].filename}` : existing[0].banner;

    await query(
      `UPDATE collections SET
        name = ?, slug = ?, description = ?, image = ?, banner = ?, type = ?,
        sort_order = ?, status = ?, meta_title = ?, meta_description = ?
       WHERE id = ?`,
      [
        name !== undefined ? name.trim() : existing[0].name,
        slug,
        description !== undefined ? description : existing[0].description,
        image,
        banner,
        type !== undefined ? type : existing[0].type,
        sort_order !== undefined ? parseInt(sort_order, 10) || 0 : existing[0].sort_order,
        status !== undefined ? status : existing[0].status,
        meta_title !== undefined ? meta_title : existing[0].meta_title,
        meta_description !== undefined ? meta_description : existing[0].meta_description,
        req.params.id,
      ]
    );

    if (product_ids !== undefined) {
      const ids = parseProductIds(product_ids);
      await query("DELETE FROM collection_products WHERE collection_id = ?", [req.params.id]);
      for (let i = 0; i < ids.length; i++) {
        await query(
          "INSERT INTO collection_products (collection_id, product_id, sort_order) VALUES (?, ?, ?)",
          [req.params.id, ids[i], i]
        );
      }
    }

    const collection = await query("SELECT * FROM collections WHERE id = ?", [req.params.id]);
    return successResponse(res, collection[0], "Collection updated successfully");
  } catch (error) {
    logger.error("Update collection error:", error);
    return errorResponse(res, "Failed to update collection", 500);
  }
};

// @desc    Delete collection (permanent)
// @route   DELETE /api/collections/:id
export const deleteCollection = async (req, res) => {
  try {
    const existing = await query("SELECT id FROM collections WHERE id = ?", [req.params.id]);
    if (!existing.length) return errorResponse(res, "Collection not found", 404);

    await query("DELETE FROM collections WHERE id = ?", [req.params.id]);
    return successResponse(res, null, "Collection deleted successfully");
  } catch (error) {
    logger.error("Delete collection error:", error);
    return errorResponse(res, "Failed to delete collection", 500);
  }
};
