import express from "express";
import { authenticate } from "../middleware/authMiddleware.js";
import { authorize } from "../middleware/roleMiddleware.js";
import { upload, uploadErrorHandler } from "../middleware/uploadMiddleware.js";
import {
  getMedia, uploadMedia, uploadMultipleMedia, updateMedia, deleteMedia, getMediaFolders,
} from "../controllers/mediaController.js";

const router = express.Router();

router.get("/folders", authenticate, authorize("super_admin", "admin", "manager"), getMediaFolders);
router.get("/", authenticate, authorize("super_admin", "admin", "manager"), getMedia);
router.post("/upload", authenticate, authorize("super_admin", "admin", "manager"), upload.single("file"), uploadErrorHandler, uploadMedia);
router.post("/upload-multiple", authenticate, authorize("super_admin", "admin", "manager"), upload.array("files", 20), uploadErrorHandler, uploadMultipleMedia);
router.put("/:id", authenticate, authorize("super_admin", "admin", "manager"), updateMedia);
router.delete("/:id", authenticate, authorize("super_admin", "admin"), deleteMedia);

export default router;