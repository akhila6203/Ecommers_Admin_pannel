import express from "express";
import { authenticate } from "../middleware/authMiddleware.js";
import { authorize } from "../middleware/roleMiddleware.js";
import { upload, uploadErrorHandler } from "../middleware/uploadMiddleware.js";
import {
  getAdmins, getAdmin, createAdmin, updateAdmin, deleteAdmin,
  getRoles, createRole, updateRole, deleteRole, getPermissions,
} from "../controllers/adminController.js";

const router = express.Router();

router.get("/roles", authenticate, authorize("super_admin"), getRoles);
router.post("/roles", authenticate, authorize("super_admin"), createRole);
router.put("/roles/:id", authenticate, authorize("super_admin"), updateRole);
router.delete("/roles/:id", authenticate, authorize("super_admin"), deleteRole);
router.get("/permissions", authenticate, authorize("super_admin"), getPermissions);

router.get("/", authenticate, authorize("super_admin", "admin"), getAdmins);
router.get("/:id", authenticate, authorize("super_admin", "admin"), getAdmin);
router.post("/", authenticate, authorize("super_admin"), upload.single("avatar"), uploadErrorHandler, createAdmin);
router.put("/:id", authenticate, authorize("super_admin"), upload.single("avatar"), uploadErrorHandler, updateAdmin);
router.delete("/:id", authenticate, authorize("super_admin"), deleteAdmin);

export default router;