import express from "express";
import { authenticate } from "../middleware/authMiddleware.js";
import { authorize } from "../middleware/roleMiddleware.js";
import { upload, productUpload, uploadErrorHandler } from "../middleware/uploadMiddleware.js";
import { auditLog } from "../middleware/auditMiddleware.js";
import { validateProduct, validateVariantOption, validateProductSeo } from "../validators/productValidator.js";
import {
  getProducts,
  getProduct,
  getProductBySlug,
  createProduct,
  updateProduct,
  deleteProduct,
  bulkDeleteProducts,
  bulkUploadProducts,
  toggleFeatured,
  toggleTrending,
  toggleBestSeller,
  updateProductStatus,
  updateStock,
  deleteProductImage,
  exportProductsExcel,
  getVariantOptions,
  createVariantOption,
  updateVariantOption,
  deleteVariantOption,
  generateVariantCombinations,
  updateVariant,
  deleteVariant,
  getProductSeo,
  updateProductSeo,
} from "../controllers/productController.js";

const router = express.Router();

const productFileFields = [
  { name: "thumbnail", maxCount: 1 },
  { name: "gallery_images", maxCount: 20 },
  { name: "variant_images", maxCount: 50 },
  { name: "images", maxCount: 20 },
];

// Public routes
router.get("/export/excel", exportProductsExcel);
router.get("/slug/:slug", getProductBySlug);

// CRUD
router.get("/", getProducts);
router.get("/:id", getProduct);
router.post("/", authenticate, authorize("super_admin", "admin", "manager"), productUpload.fields(productFileFields), uploadErrorHandler, validateProduct, auditLog("create", "product"), createProduct);
router.put("/:id", authenticate, authorize("super_admin", "admin", "manager"), productUpload.fields(productFileFields), uploadErrorHandler, validateProduct, auditLog("update", "product"), updateProduct);
router.delete("/:id", authenticate, authorize("super_admin", "admin"), auditLog("delete", "product"), deleteProduct);

// Bulk operations
router.post("/bulk-delete", authenticate, authorize("super_admin", "admin"), bulkDeleteProducts);
router.post("/bulk-upload", authenticate, authorize("super_admin", "admin"), bulkUploadProducts);

// Toggle routes
router.put("/:id/featured", authenticate, authorize("super_admin", "admin", "manager"), toggleFeatured);
router.put("/:id/trending", authenticate, authorize("super_admin", "admin", "manager"), toggleTrending);
router.put("/:id/best-seller", authenticate, authorize("super_admin", "admin", "manager"), toggleBestSeller);

// Status & Stock
router.put("/:id/status", authenticate, authorize("super_admin", "admin", "manager"), updateProductStatus);
router.put("/:id/stock", authenticate, authorize("super_admin", "admin", "manager"), updateStock);

// Images
router.delete("/:id/images/:imageId", authenticate, authorize("super_admin", "admin"), deleteProductImage);

// ============================================================
// VARIANT OPTIONS ROUTES
// ============================================================
router.get("/:productId/variant-options", getVariantOptions);
router.post("/:productId/variant-options", authenticate, authorize("super_admin", "admin", "manager"), validateVariantOption, createVariantOption);
router.put("/:productId/variant-options/:optionId", authenticate, authorize("super_admin", "admin", "manager"), validateVariantOption, updateVariantOption);
router.delete("/:productId/variant-options/:optionId", authenticate, authorize("super_admin", "admin"), deleteVariantOption);

// Variant combinations (auto-generate)
router.post("/:productId/variant-combinations/generate", authenticate, authorize("super_admin", "admin", "manager"), generateVariantCombinations);

// Individual variant update / delete
router.put("/:productId/variants/:variantId", authenticate, authorize("super_admin", "admin", "manager"), updateVariant);
router.delete("/:productId/variants/:variantId", authenticate, authorize("super_admin", "admin"), deleteVariant);

// ============================================================
// SEO ROUTES
// ============================================================
router.get("/:productId/seo", getProductSeo);
router.put("/:productId/seo", authenticate, authorize("super_admin", "admin", "manager"), validateProductSeo, auditLog("update", "product_seo"), updateProductSeo);

export default router;