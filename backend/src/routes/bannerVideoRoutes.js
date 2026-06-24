import express from "express";
import { authenticate } from "../middleware/authMiddleware.js";
import { authorize } from "../middleware/roleMiddleware.js";
import { videoUpload, uploadErrorHandler } from "../middleware/uploadMiddleware.js";
import {
  getBannerVideos,
  getBannerVideo,
  createBannerVideo,
  updateBannerVideo,
  deleteBannerVideo,
} from "../controllers/bannerVideoController.js";

const router = express.Router();

router.get("/", getBannerVideos);
router.get("/:id", getBannerVideo);
router.post(
  "/",
  authenticate,
  authorize("super_admin", "admin"),
  videoUpload.single("video"),
  uploadErrorHandler,
  createBannerVideo
);
router.put(
  "/:id",
  authenticate,
  authorize("super_admin", "admin"),
  videoUpload.single("video"),
  uploadErrorHandler,
  updateBannerVideo
);
router.delete("/:id", authenticate, authorize("super_admin", "admin"), deleteBannerVideo);

export default router;
