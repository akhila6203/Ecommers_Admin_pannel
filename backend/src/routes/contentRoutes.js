import express from "express";
import { authenticate } from "../middleware/authMiddleware.js";
import { authorize } from "../middleware/roleMiddleware.js";
import { upload, uploadErrorHandler } from "../middleware/uploadMiddleware.js";
import { getContentPage, updateContentPage } from "../controllers/contentController.js";

const router = express.Router();

router.get("/:page_key", getContentPage);
router.put("/:page_key", authenticate, authorize("super_admin", "admin"), upload.single("image"), uploadErrorHandler, updateContentPage);

export default router;
