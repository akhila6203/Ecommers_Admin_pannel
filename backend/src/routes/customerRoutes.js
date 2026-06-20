import express from "express";
import { authenticate } from "../middleware/authMiddleware.js";
import { authorize } from "../middleware/roleMiddleware.js";
import {
  getCustomers,
  getCustomer,
  createCustomer,
  updateCustomer,
  blockCustomer,
  deleteCustomer,
  getCustomerAnalytics,
} from "../controllers/customerController.js";

const router = express.Router();

router.get("/analytics", authenticate, authorize("super_admin", "admin"), getCustomerAnalytics);
router.get("/", authenticate, authorize("super_admin", "admin", "manager", "staff"), getCustomers);
router.get("/:id", authenticate, authorize("super_admin", "admin", "manager", "staff"), getCustomer);
router.post("/", authenticate, authorize("super_admin", "admin"), createCustomer);
router.put("/:id", authenticate, authorize("super_admin", "admin", "manager"), updateCustomer);
router.put("/:id/block", authenticate, authorize("super_admin", "admin"), blockCustomer);
router.delete("/:id", authenticate, authorize("super_admin", "admin"), deleteCustomer);

export default router;