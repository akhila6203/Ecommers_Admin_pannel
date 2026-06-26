import express from "express";
import { createPayment, verifyPayment } from "../controllers/storefrontPaymentController.js";
import { authenticateCustomer } from "../middleware/customerAuthMiddleware.js";

const router = express.Router();

router.post("/create", authenticateCustomer, createPayment);
router.post("/verify", authenticateCustomer, verifyPayment);

export default router;
