import { errorResponse } from "../helpers/responseHelper.js";

export const validateCategory = (req, res, next) => {
  const { name } = req.body;
  const errors = [];

  if (!name || typeof name !== "string" || !name.trim()) {
    errors.push("Category name is required");
  }

  if (errors.length) return errorResponse(res, "Validation failed", 400, errors);
  next();
};

export const validateSubCategory = (req, res, next) => {
  const { name, main_category_id } = req.body;
  const errors = [];

  if (!name || typeof name !== "string" || !name.trim()) {
    errors.push("Sub category name is required");
  }
  if (!main_category_id) {
    errors.push("Main category ID is required");
  }

  if (errors.length) return errorResponse(res, "Validation failed", 400, errors);
  next();
};

export const validateSubCategoryUpdate = (req, res, next) => {
  const { name } = req.body;
  const errors = [];

  if (!name || typeof name !== "string" || !name.trim()) {
    errors.push("Sub category name is required");
  }

  if (errors.length) return errorResponse(res, "Validation failed", 400, errors);
  next();
};

export const validateChildCategory = (req, res, next) => {
  const { name, sub_category_id } = req.body;
  const errors = [];

  if (!name || typeof name !== "string" || !name.trim()) {
    errors.push("Child category name is required");
  }
  if (!sub_category_id) {
    errors.push("Sub category ID is required");
  }

  if (errors.length) return errorResponse(res, "Validation failed", 400, errors);
  next();
};

export const validateChildCategoryUpdate = (req, res, next) => {
  const { name } = req.body;
  const errors = [];

  if (!name || typeof name !== "string" || !name.trim()) {
    errors.push("Child category name is required");
  }

  if (errors.length) return errorResponse(res, "Validation failed", 400, errors);
  next();
};
