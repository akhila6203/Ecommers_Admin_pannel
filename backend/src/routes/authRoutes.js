import express from "express";
import { authenticate } from "../middleware/authMiddleware.js";
import { authLimiter } from "../middleware/rateLimiterMiddleware.js";
import { validateLogin, validateForgotPassword, validateResetPassword, validateChangePassword } from "../validators/authValidator.js";
import {
  login,
  logout,
  forgotPassword,
  resetPassword,
  changePassword,
  refreshToken,
  getProfile,
  updateProfile,
} from "../controllers/authController.js";

const router = express.Router();

router.post("/login", authLimiter, validateLogin, login);
router.post("/logout", authenticate, logout);
router.post("/forgot-password", authLimiter, validateForgotPassword, forgotPassword);
router.post("/reset-password", validateResetPassword, resetPassword);
router.post("/change-password", authenticate, validateChangePassword, changePassword);
router.post("/refresh-token", refreshToken);
router.get("/profile", authenticate, getProfile);
router.put("/profile", authenticate, updateProfile);

export default router;