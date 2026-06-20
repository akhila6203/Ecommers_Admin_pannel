import express from "express";
import { authenticate } from "../middleware/authMiddleware.js";
import { authorize } from "../middleware/roleMiddleware.js";
import { upload, uploadErrorHandler } from "../middleware/uploadMiddleware.js";
import { getCollections, getCollection, createCollection, updateCollection, deleteCollection } from "../controllers/collectionController.js";

const router = express.Router();

router.get("/", authenticate, authorize("super_admin", "admin", "manager", "staff"), getCollections);
router.get("/:id", authenticate, authorize("super_admin", "admin", "manager", "staff"), getCollection);
router.post("/", authenticate, authorize("super_admin", "admin"), upload.fields([{ name: "image", maxCount: 1 }, { name: "banner", maxCount: 1 }]), uploadErrorHandler, createCollection);
router.put("/:id", authenticate, authorize("super_admin", "admin"), upload.fields([{ name: "image", maxCount: 1 }, { name: "banner", maxCount: 1 }]), uploadErrorHandler, updateCollection);
router.delete("/:id", authenticate, authorize("super_admin", "admin"), deleteCollection);

export default router;