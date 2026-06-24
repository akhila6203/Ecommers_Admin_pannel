import express from "express";
import { authenticate } from "../middleware/authMiddleware.js";
import { authorize } from "../middleware/roleMiddleware.js";
import {
  getStores,
  getStore,
  createStore,
  updateStore,
  deleteStore,
  getCurrentStore,
} from "../controllers/storeController.js";

const router = express.Router();

router.get("/", authenticate, authorize("super_admin", "admin"), getStores);
router.get("/current", getCurrentStore);
router.get("/:id", authenticate, authorize("super_admin", "admin"), getStore);
router.post("/", authenticate, authorize("super_admin"), createStore);
router.put("/:id", authenticate, authorize("super_admin"), updateStore);
router.delete("/:id", authenticate, authorize("super_admin"), deleteStore);

export default router;
