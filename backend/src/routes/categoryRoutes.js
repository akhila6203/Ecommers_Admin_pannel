import express from "express";
import { authenticate } from "../middleware/authMiddleware.js";
import { authorize } from "../middleware/roleMiddleware.js";
import { upload, uploadErrorHandler } from "../middleware/uploadMiddleware.js";
import { auditLog } from "../middleware/auditMiddleware.js";
import {
  validateCategory,
  validateSubCategory,
  validateSubCategoryUpdate,
  validateChildCategory,
  validateChildCategoryUpdate,
} from "../validators/categoryValidator.js";
import {
  getCategories,
  getAllCategories,
  getCategory,
  createCategory,
  updateCategory,
  deleteCategory,
  toggleCategoryStatus,
  getSubCategories,
  createSubCategory,
  updateSubCategory,
  deleteSubCategory,
  getChildCategories,
  createChildCategory,
  updateChildCategory,
  deleteChildCategory,
  getCategoryHierarchy,
} from "../controllers/categoryController.js";

const router = express.Router();

// Hierarchy
router.get("/hierarchy", getCategoryHierarchy);
router.get("/all", getAllCategories);

// Main Categories
router.get("/", getCategories);
router.get("/:id", getCategory);
router.post("/", authenticate, authorize("super_admin", "admin"), upload.single("image"), uploadErrorHandler, validateCategory, auditLog("create", "category"), createCategory);
router.put("/:id", authenticate, authorize("super_admin", "admin"), upload.single("image"), uploadErrorHandler, auditLog("update", "category"), updateCategory);
router.delete("/:id", authenticate, authorize("super_admin", "admin"), auditLog("delete", "category"), deleteCategory);
router.put("/:id/status", authenticate, authorize("super_admin", "admin", "manager"), toggleCategoryStatus);

// Sub Categories
router.get("/:mainId/sub", getSubCategories);
router.post("/sub", authenticate, authorize("super_admin", "admin"), upload.single("image"), uploadErrorHandler, validateSubCategory, auditLog("create", "sub_category"), createSubCategory);
router.put("/sub/:id", authenticate, authorize("super_admin", "admin"), upload.single("image"), uploadErrorHandler, validateSubCategoryUpdate, auditLog("update", "sub_category"), updateSubCategory);
router.delete("/sub/:id", authenticate, authorize("super_admin", "admin"), auditLog("delete", "sub_category"), deleteSubCategory);

// Child Categories
router.get("/sub/:subId/child", getChildCategories);
router.post("/child", authenticate, authorize("super_admin", "admin"), upload.single("image"), uploadErrorHandler, validateChildCategory, auditLog("create", "child_category"), createChildCategory);
router.put("/child/:id", authenticate, authorize("super_admin", "admin"), upload.single("image"), uploadErrorHandler, validateChildCategoryUpdate, auditLog("update", "child_category"), updateChildCategory);
router.delete("/child/:id", authenticate, authorize("super_admin", "admin"), auditLog("delete", "child_category"), deleteChildCategory);

export default router;
