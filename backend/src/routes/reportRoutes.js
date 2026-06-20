import express from "express";
import { authenticate } from "../middleware/authMiddleware.js";
import { authorize } from "../middleware/roleMiddleware.js";
import {
  getSalesReport, getOrderReport, getCustomerReport,
  getProductReport, getInventoryReport, getGstReport, getReportSummary,
} from "../controllers/reportController.js";

const router = express.Router();

router.get("/summary", authenticate, authorize("super_admin", "admin"), getReportSummary);
router.get("/sales", authenticate, authorize("super_admin", "admin", "manager"), getSalesReport);
router.get("/orders", authenticate, authorize("super_admin", "admin", "manager"), getOrderReport);
router.get("/customers", authenticate, authorize("super_admin", "admin", "manager"), getCustomerReport);
router.get("/products", authenticate, authorize("super_admin", "admin", "manager"), getProductReport);
router.get("/inventory", authenticate, authorize("super_admin", "admin", "manager"), getInventoryReport);
router.get("/gst", authenticate, authorize("super_admin", "admin"), getGstReport);

export default router;