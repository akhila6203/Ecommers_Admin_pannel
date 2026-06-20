import express from "express";
import { authenticate } from "../middleware/authMiddleware.js";
import { authorize } from "../middleware/roleMiddleware.js";
import { upload, uploadErrorHandler } from "../middleware/uploadMiddleware.js";
import { getBanners, getBanner, createBanner, updateBanner, deleteBanner } from "../controllers/bannerController.js";

const router = express.Router();

router.get("/", getBanners);
router.get("/:id", getBanner);
router.post("/", authenticate, authorize("super_admin", "admin"), upload.single("image"), uploadErrorHandler, createBanner);
router.put("/:id", authenticate, authorize("super_admin", "admin"), upload.single("image"), uploadErrorHandler, updateBanner);
router.delete("/:id", authenticate, authorize("super_admin", "admin"), deleteBanner);

export default router;