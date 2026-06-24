import express from "express";
import { authenticate } from "../middleware/authMiddleware.js";
import { authorize } from "../middleware/roleMiddleware.js";
import {
  getCoupons,
  getCoupon,
  createCoupon,
  updateCoupon,
  deleteCoupon,
  validateCoupon,
  getCouponUsage,
  getAllCouponUsage,
} from "../controllers/couponController.js";

const router = express.Router();

router.get("/usage/all", authenticate, authorize("super_admin", "admin", "manager"), getAllCouponUsage);
router.post("/validate", authenticate, authorize("super_admin", "admin", "manager"), validateCoupon);
router.get("/", authenticate, authorize("super_admin", "admin", "manager"), getCoupons);
router.get("/:id/usage", authenticate, authorize("super_admin", "admin", "manager"), getCouponUsage);
router.get("/:id", authenticate, authorize("super_admin", "admin", "manager"), getCoupon);
router.post("/", authenticate, authorize("super_admin", "admin"), createCoupon);
router.put("/:id", authenticate, authorize("super_admin", "admin"), updateCoupon);
router.delete("/:id", authenticate, authorize("super_admin", "admin"), deleteCoupon);

export default router;
