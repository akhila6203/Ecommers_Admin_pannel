import express from "express";
import { authenticate } from "../middleware/authMiddleware.js";
import { authorize } from "../middleware/roleMiddleware.js";
import {
  getOrders,
  getOrder,
  getOrderStats,
  createOrder,
  updateOrderStatus,
  updatePaymentStatus,
  addOrderNote,
  generateInvoice,
  deleteOrder,
  exportOrders,
  createShiprocketShipment,
  syncShiprocketTracking,
  generateShippingLabel,
  scheduleShiprocketPickup,
} from "../controllers/orderController.js";

const router = express.Router();

router.get("/export", authenticate, authorize("super_admin", "admin", "manager"), exportOrders);
router.get("/stats", authenticate, authorize("super_admin", "admin", "manager", "staff"), getOrderStats);
router.get("/", authenticate, authorize("super_admin", "admin", "manager", "staff"), getOrders);
router.post(
  "/:id/shiprocket/create-shipment",
  authenticate,
  authorize("super_admin", "admin", "manager"),
  createShiprocketShipment
);
router.post(
  "/:id/shiprocket/sync-tracking",
  authenticate,
  authorize("super_admin", "admin", "manager", "staff"),
  syncShiprocketTracking
);
router.post(
  "/:id/shiprocket/generate-label",
  authenticate,
  authorize("super_admin", "admin", "manager"),
  generateShippingLabel
);

router.post(
  "/:id/shiprocket/schedule-pickup",
  authenticate,
  authorize("super_admin", "admin", "manager"),
  scheduleShiprocketPickup
);
router.get("/:id", authenticate, authorize("super_admin", "admin", "manager", "staff"), getOrder);
router.post("/", authenticate, authorize("super_admin", "admin", "manager"), createOrder);
router.put("/:id/status", authenticate, authorize("super_admin", "admin", "manager"), updateOrderStatus);
router.put("/:id/payment", authenticate, authorize("super_admin", "admin"), updatePaymentStatus);
router.post("/:id/notes", authenticate, authorize("super_admin", "admin", "manager"), addOrderNote);
router.get("/:id/invoice", authenticate, authorize("super_admin", "admin", "manager"), generateInvoice);
router.delete("/:id", authenticate, authorize("super_admin", "admin"), deleteOrder);

export default router;