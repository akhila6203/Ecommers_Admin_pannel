import { query } from "../config/db.js";
import { generateUniqueSlug } from "../helpers/slugHelper.js";
import { successResponse, errorResponse, paginatedResponse } from "../helpers/responseHelper.js";
import logger from "../config/logger.js";

const MAIN_COLUMNS = "id, name, slug, created_at, updated_at";
const SUB_COLUMNS = "id, main_category_id, name, slug, created_at, updated_at";
const CHILD_COLUMNS = "id, sub_category_id, name, slug, created_at, updated_at";

const checkCategorySlug = async (slug, excludeId = null) => {
  let sql = "SELECT id FROM categories WHERE slug = ?";
  const params = [slug];
  if (excludeId) {
    sql += " AND id != ?";
    params.push(excludeId);
  }
  const result = await query(sql, params);
  return result.length > 0 ? result[0] : null;
};

const checkSubCategorySlug = async (slug, excludeId = null) => {
  let sql = "SELECT id FROM sub_categories WHERE slug = ?";
  const params = [slug];
  if (excludeId) {
    sql += " AND id != ?";
    params.push(excludeId);
  }
  const result = await query(sql, params);
  return result.length > 0 ? result[0] : null;
};

const checkChildCategorySlug = async (slug, excludeId = null) => {
  let sql = "SELECT id FROM child_categories WHERE slug = ?";
  const params = [slug];
  if (excludeId) {
    sql += " AND id != ?";
    params.push(excludeId);
  }
  const result = await query(sql, params);
  return result.length > 0 ? result[0] : null;
};

// ==================== MAIN CATEGORIES ====================

export const getCategories = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 50;
    const offset = (page - 1) * limit;
    const search = req.query.search || "";

    let whereClause = "WHERE 1=1";
    const params = [];

    if (search) {
      whereClause += " AND (c.name LIKE ? OR c.slug LIKE ?)";
      params.push(`%${search}%`, `%${search}%`);
    }

    const countResult = await query(`SELECT COUNT(*) as total FROM categories c ${whereClause}`, params);
    const total = countResult[0].total;

    const categories = await query(
      `SELECT c.id, c.name, c.slug, c.created_at, c.updated_at,
        (SELECT COUNT(*) FROM sub_categories WHERE main_category_id = c.id) as sub_category_count,
        (SELECT COUNT(*) FROM products WHERE category_id = c.id) as product_count
       FROM categories c ${whereClause}
       ORDER BY c.name ASC
       LIMIT ? OFFSET ?`,
      [...params, String(limit), String(offset)]
    );

    return paginatedResponse(res, categories, total, page, limit);
  } catch (error) {
    logger.error("Get categories error:", error);
    return errorResponse(res, process.env.NODE_ENV === "development" ? error.message : "Failed to fetch categories", 500);
  }
};

export const getAllCategories = async (req, res) => {
  try {
    const categories = await query(
      `SELECT id, name, slug FROM categories ORDER BY name ASC`
    );
    return successResponse(res, categories);
  } catch (error) {
    logger.error("Get all categories error:", error);
    return errorResponse(res, process.env.NODE_ENV === "development" ? error.message : "Failed to fetch categories", 500);
  }
};

export const getCategory = async (req, res) => {
  try {
    const categories = await query(`SELECT ${MAIN_COLUMNS} FROM categories WHERE id = ?`, [req.params.id]);
    if (!categories.length) {
      return errorResponse(res, "Category not found", 404);
    }

    const subCategories = await query(
      `SELECT ${SUB_COLUMNS} FROM sub_categories WHERE main_category_id = ? ORDER BY name ASC`,
      [req.params.id]
    );

    return successResponse(res, { ...categories[0], sub_categories: subCategories });
  } catch (error) {
    logger.error("Get category error:", error);
    return errorResponse(res, process.env.NODE_ENV === "development" ? error.message : "Failed to fetch category", 500);
  }
};

export const createCategory = async (req, res) => {
  try {
    const { name } = req.body;
    const slug = await generateUniqueSlug(checkCategorySlug, name);

    const result = await query(
      "INSERT INTO categories (name, slug) VALUES (?, ?)",
      [name, slug]
    );

    const category = await query(`SELECT ${MAIN_COLUMNS} FROM categories WHERE id = ?`, [result.insertId]);
    return successResponse(res, category[0], "Category created successfully", 201);
  } catch (error) {
    logger.error("Create category error:", error);
    return errorResponse(res, process.env.NODE_ENV === "development" ? error.message : "Failed to create category", 500);
  }
};

export const updateCategory = async (req, res) => {
  try {
    const { name } = req.body;
    const categoryId = req.params.id;

    const existing = await query(`SELECT ${MAIN_COLUMNS} FROM categories WHERE id = ?`, [categoryId]);
    if (!existing.length) {
      return errorResponse(res, "Category not found", 404);
    }

    let slug = existing[0].slug;
    if (name && name !== existing[0].name) {
      slug = await generateUniqueSlug(checkCategorySlug, name, categoryId);
    }

    await query(
      "UPDATE categories SET name = ?, slug = ? WHERE id = ?",
      [name || existing[0].name, slug, categoryId]
    );

    const category = await query(`SELECT ${MAIN_COLUMNS} FROM categories WHERE id = ?`, [categoryId]);
    return successResponse(res, category[0], "Category updated successfully");
  } catch (error) {
    logger.error("Update category error:", error);
    return errorResponse(res, process.env.NODE_ENV === "development" ? error.message : "Failed to update category", 500);
  }
};

export const deleteCategory = async (req, res) => {
  try {
    const existing = await query("SELECT id FROM categories WHERE id = ?", [req.params.id]);
    if (!existing.length) {
      return errorResponse(res, "Category not found", 404);
    }

    await query("DELETE FROM categories WHERE id = ?", [req.params.id]);
    return successResponse(res, null, "Category deleted successfully");
  } catch (error) {
    logger.error("Delete category error:", error);
    return errorResponse(res, process.env.NODE_ENV === "development" ? error.message : "Failed to delete category", 500);
  }
};

export const toggleCategoryStatus = async (req, res) => {
  return errorResponse(res, "Category status is not used in admin UI", 400);
};

// ==================== SUB CATEGORIES ====================

export const getSubCategories = async (req, res) => {
  try {
    const { mainId } = req.params;
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 50;
    const offset = (page - 1) * limit;

    const whereClause = mainId !== "all" ? "WHERE sc.main_category_id = ?" : "WHERE 1=1";
    const params = mainId !== "all" ? [mainId] : [];

    const countResult = await query(`SELECT COUNT(*) as total FROM sub_categories sc ${whereClause}`, params);
    const total = countResult[0].total;

    const subCategories = await query(
      `SELECT sc.id, sc.main_category_id, sc.name, sc.slug, sc.created_at, sc.updated_at,
        c.name as main_category_name,
        (SELECT COUNT(*) FROM child_categories WHERE sub_category_id = sc.id) as child_count
       FROM sub_categories sc
       LEFT JOIN categories c ON sc.main_category_id = c.id
       ${whereClause}
       ORDER BY sc.name ASC
       LIMIT ? OFFSET ?`,
      [...params, String(limit), String(offset)]
    );

    return paginatedResponse(res, subCategories, total, page, limit);
  } catch (error) {
    logger.error("Get sub categories error:", error);
    return errorResponse(res, process.env.NODE_ENV === "development" ? error.message : "Failed to fetch sub categories", 500);
  }
};

export const createSubCategory = async (req, res) => {
  try {
    const { name, main_category_id } = req.body;
    const slug = await generateUniqueSlug(checkSubCategorySlug, name);

    const result = await query(
      "INSERT INTO sub_categories (name, slug, main_category_id) VALUES (?, ?, ?)",
      [name, slug, main_category_id]
    );

    const subCategory = await query(`SELECT ${SUB_COLUMNS} FROM sub_categories WHERE id = ?`, [result.insertId]);
    return successResponse(res, subCategory[0], "Sub category created successfully", 201);
  } catch (error) {
    logger.error("Create sub category error:", error);
    return errorResponse(res, process.env.NODE_ENV === "development" ? error.message : "Failed to create sub category", 500);
  }
};

export const updateSubCategory = async (req, res) => {
  try {
    const { name, main_category_id } = req.body;
    const subId = req.params.id;

    const existing = await query(`SELECT ${SUB_COLUMNS} FROM sub_categories WHERE id = ?`, [subId]);
    if (!existing.length) {
      return errorResponse(res, "Sub category not found", 404);
    }

    let slug = existing[0].slug;
    if (name && name !== existing[0].name) {
      slug = await generateUniqueSlug(checkSubCategorySlug, name, subId);
    }

    await query(
      "UPDATE sub_categories SET name = ?, slug = ?, main_category_id = ? WHERE id = ?",
      [name || existing[0].name, slug, main_category_id || existing[0].main_category_id, subId]
    );

    const subCategory = await query(`SELECT ${SUB_COLUMNS} FROM sub_categories WHERE id = ?`, [subId]);
    return successResponse(res, subCategory[0], "Sub category updated successfully");
  } catch (error) {
    logger.error("Update sub category error:", error);
    return errorResponse(res, process.env.NODE_ENV === "development" ? error.message : "Failed to update sub category", 500);
  }
};

export const deleteSubCategory = async (req, res) => {
  try {
    const existing = await query("SELECT id FROM sub_categories WHERE id = ?", [req.params.id]);
    if (!existing.length) {
      return errorResponse(res, "Sub category not found", 404);
    }

    await query("DELETE FROM sub_categories WHERE id = ?", [req.params.id]);
    return successResponse(res, null, "Sub category deleted successfully");
  } catch (error) {
    logger.error("Delete sub category error:", error);
    return errorResponse(res, process.env.NODE_ENV === "development" ? error.message : "Failed to delete sub category", 500);
  }
};

// ==================== CHILD CATEGORIES ====================

export const getChildCategories = async (req, res) => {
  try {
    const { subId } = req.params;
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 50;
    const offset = (page - 1) * limit;

    const whereClause = subId !== "all" ? "WHERE cc.sub_category_id = ?" : "WHERE 1=1";
    const params = subId !== "all" ? [subId] : [];

    const countResult = await query(`SELECT COUNT(*) as total FROM child_categories cc ${whereClause}`, params);
    const total = countResult[0].total;

    const childCategories = await query(
      `SELECT cc.id, cc.sub_category_id, cc.name, cc.slug, cc.created_at, cc.updated_at,
        sc.name as sub_category_name, c.name as main_category_name
       FROM child_categories cc
       LEFT JOIN sub_categories sc ON cc.sub_category_id = sc.id
       LEFT JOIN categories c ON sc.main_category_id = c.id
       ${whereClause}
       ORDER BY cc.name ASC
       LIMIT ? OFFSET ?`,
      [...params, String(limit), String(offset)]
    );

    return paginatedResponse(res, childCategories, total, page, limit);
  } catch (error) {
    logger.error("Get child categories error:", error);
    return errorResponse(res, process.env.NODE_ENV === "development" ? error.message : "Failed to fetch child categories", 500);
  }
};

export const createChildCategory = async (req, res) => {
  try {
    const { name, sub_category_id } = req.body;
    const slug = await generateUniqueSlug(checkChildCategorySlug, name);

    const result = await query(
      "INSERT INTO child_categories (name, slug, sub_category_id) VALUES (?, ?, ?)",
      [name, slug, sub_category_id]
    );

    const childCategory = await query(`SELECT ${CHILD_COLUMNS} FROM child_categories WHERE id = ?`, [result.insertId]);
    return successResponse(res, childCategory[0], "Child category created successfully", 201);
  } catch (error) {
    logger.error("Create child category error:", error);
    return errorResponse(res, process.env.NODE_ENV === "development" ? error.message : "Failed to create child category", 500);
  }
};

export const updateChildCategory = async (req, res) => {
  try {
    const { name, sub_category_id } = req.body;
    const childId = req.params.id;

    const existing = await query(`SELECT ${CHILD_COLUMNS} FROM child_categories WHERE id = ?`, [childId]);
    if (!existing.length) {
      return errorResponse(res, "Child category not found", 404);
    }

    let slug = existing[0].slug;
    if (name && name !== existing[0].name) {
      slug = await generateUniqueSlug(checkChildCategorySlug, name, childId);
    }

    await query(
      "UPDATE child_categories SET name = ?, slug = ?, sub_category_id = ? WHERE id = ?",
      [name || existing[0].name, slug, sub_category_id || existing[0].sub_category_id, childId]
    );

    const childCategory = await query(`SELECT ${CHILD_COLUMNS} FROM child_categories WHERE id = ?`, [childId]);
    return successResponse(res, childCategory[0], "Child category updated successfully");
  } catch (error) {
    logger.error("Update child category error:", error);
    return errorResponse(res, process.env.NODE_ENV === "development" ? error.message : "Failed to update child category", 500);
  }
};

export const deleteChildCategory = async (req, res) => {
  try {
    const existing = await query("SELECT id FROM child_categories WHERE id = ?", [req.params.id]);
    if (!existing.length) {
      return errorResponse(res, "Child category not found", 404);
    }

    await query("DELETE FROM child_categories WHERE id = ?", [req.params.id]);
    return successResponse(res, null, "Child category deleted successfully");
  } catch (error) {
    logger.error("Delete child category error:", error);
    return errorResponse(res, process.env.NODE_ENV === "development" ? error.message : "Failed to delete child category", 500);
  }
};

export const getCategoryHierarchy = async (req, res) => {
  try {
    const categories = await query(
      "SELECT id, name, slug FROM categories ORDER BY name ASC"
    );

    for (const cat of categories) {
      cat.sub_categories = await query(
        "SELECT id, name, slug, main_category_id FROM sub_categories WHERE main_category_id = ? ORDER BY name ASC",
        [cat.id]
      );
      for (const sub of cat.sub_categories) {
        sub.child_categories = await query(
          "SELECT id, name, slug, sub_category_id FROM child_categories WHERE sub_category_id = ? ORDER BY name ASC",
          [sub.id]
        );
      }
    }

    return successResponse(res, categories);
  } catch (error) {
    logger.error("Get category hierarchy error:", error);
    return errorResponse(res, process.env.NODE_ENV === "development" ? error.message : "Failed to fetch hierarchy", 500);
  }
};
