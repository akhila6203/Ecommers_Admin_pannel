import express from "express";
import { checkout, getMyOrders, getMyOrder } from "../controllers/storefrontOrderController.js";
import { authenticateCustomer } from "../middleware/customerAuthMiddleware.js";

const router = express.Router();

router.use(authenticateCustomer);

router.post("/checkout", checkout);
router.get("/", getMyOrders);
router.get("/:id", getMyOrder);

export default router;
