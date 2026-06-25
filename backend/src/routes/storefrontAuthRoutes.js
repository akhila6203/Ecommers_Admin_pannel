import express from "express";
import { register, login, logout, getProfile, updateProfile } from "../controllers/storefrontAuthController.js";
import { authenticateCustomer } from "../middleware/customerAuthMiddleware.js";
import { optionalCustomerAuth } from "../middleware/customerAuthMiddleware.js";

const router = express.Router();

router.post("/register", optionalCustomerAuth, register);
router.post("/login", optionalCustomerAuth, login);
router.post("/logout", authenticateCustomer, logout);
router.get("/profile", authenticateCustomer, getProfile);
router.put("/profile", authenticateCustomer, updateProfile);

export default router;
