import express from "express";
import {
  register,
  login,
  logout,
  getProfile,
  updateProfile,
  getAddresses,
  createAddress,
  updateAddress,
  deleteAddress,
  setDefaultAddress,
} from "../controllers/storefrontAuthController.js";
import { authenticateCustomer, optionalCustomerAuth } from "../middleware/customerAuthMiddleware.js";
import { upload, uploadErrorHandler } from "../middleware/uploadMiddleware.js";

const router = express.Router();

router.post("/register", optionalCustomerAuth, register);
router.post("/login", optionalCustomerAuth, login);
router.post("/logout", authenticateCustomer, logout);
router.get("/profile", authenticateCustomer, getProfile);
router.put("/profile", authenticateCustomer, upload.single("avatar"), uploadErrorHandler, updateProfile);

router.get("/addresses", authenticateCustomer, getAddresses);
router.post("/addresses", authenticateCustomer, createAddress);
router.put("/addresses/:id", authenticateCustomer, updateAddress);
router.delete("/addresses/:id", authenticateCustomer, deleteAddress);
router.put("/addresses/:id/default", authenticateCustomer, setDefaultAddress);

export default router;
