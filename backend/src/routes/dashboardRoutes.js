import express from "express";
import { authenticate } from "../middleware/authMiddleware.js";
import { authorize } from "../middleware/roleMiddleware.js";
import {
  getDashboardStats,
  getRevenueAnalytics,
  getSalesAnalytics,
  getOrderAnalytics,
} from "../controllers/dashboardController.js";

const router = express.Router();

router.get("/stats", authenticate, authorize("super_admin", "admin", "manager"), getDashboardStats);
router.get("/revenue", authenticate, authorize("super_admin", "admin"), getRevenueAnalytics);
router.get("/sales", authenticate, authorize("super_admin", "admin", "manager"), getSalesAnalytics);
router.get("/orders", authenticate, authorize("super_admin", "admin", "manager"), getOrderAnalytics);

export default router;