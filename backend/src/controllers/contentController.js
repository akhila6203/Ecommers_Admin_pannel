import { query } from "../config/db.js";
import { successResponse, errorResponse } from "../helpers/responseHelper.js";
import logger from "../config/logger.js";

// @desc    Get content page details by key
// @route   GET /api/content/:page_key
export const getContentPage = async (req, res) => {
  try {
    const { page_key } = req.params;
    const rows = await query("SELECT * FROM content_pages WHERE page_key = ?", [page_key]);
    
    if (rows.length > 0) {
      const page = rows[0];
      if (page_key === "contact") {
        try {
          page.content = JSON.parse(page.content);
        } catch (e) {
          page.content = {};
        }
      }
      return successResponse(res, page);
    }
    
    // Return empty defaults if not exists
    const defaults = {
      page_key,
      title: "",
      content: page_key === "contact" ? {} : "",
      image: null,
      status: "active"
    };
    return successResponse(res, defaults);
  } catch (error) {
    logger.error(`Get content page error (${req.params.page_key}):`, error);
    return errorResponse(res, "Failed to fetch content page", 500);
  }
};

// @desc    Update or create content page details by key
// @route   PUT /api/content/:page_key
export const updateContentPage = async (req, res) => {
  try {
    const { page_key } = req.params;
    const { title, content, status } = req.body;
    
    // Query existing to get current image
    const existing = await query("SELECT image FROM content_pages WHERE page_key = ?", [page_key]);
    
    let image = existing.length > 0 ? existing[0].image : null;
    if (req.file) {
      image = `uploads/content/${req.file.filename}`;
    } else if (req.body.image === "null" || req.body.image === null || req.body.image === "") {
      image = null;
    }
    
    const finalContent = typeof content === "object" ? JSON.stringify(content) : content;
    
    await query(
      `INSERT INTO content_pages (page_key, title, content, image, status)
       VALUES (?, ?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE 
         title = VALUES(title), 
         content = VALUES(content), 
         image = VALUES(image), 
         status = VALUES(status)`,
      [page_key, title || null, finalContent || null, image, status || "active"]
    );
    
    // Query updated page
    const updated = await query("SELECT * FROM content_pages WHERE page_key = ?", [page_key]);
    const responseData = updated[0];
    if (page_key === "contact") {
      try {
        responseData.content = JSON.parse(responseData.content);
      } catch (e) {
        responseData.content = {};
      }
    }
    
    return successResponse(res, responseData, `${page_key} page updated successfully`);
  } catch (error) {
    logger.error(`Update content page error (${req.params.page_key}):`, error);
    return errorResponse(res, "Failed to update content page", 500);
  }
};
