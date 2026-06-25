import express from "express";
import {
  getWishlist,
  addToWishlist,
  removeFromWishlist,
  toggleWishlist,
  checkWishlist,
} from "../controllers/wishlistController.js";
import { authenticateCustomer } from "../middleware/customerAuthMiddleware.js";

const router = express.Router();

router.use(authenticateCustomer);

router.get("/", getWishlist);
router.post("/", addToWishlist);
router.post("/toggle", toggleWishlist);
router.get("/check/:productId", checkWishlist);
router.delete("/:productId", removeFromWishlist);

export default router;
