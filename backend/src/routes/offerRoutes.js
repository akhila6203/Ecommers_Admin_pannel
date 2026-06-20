import express from "express";
import { authenticate } from "../middleware/authMiddleware.js";
import { authorize } from "../middleware/roleMiddleware.js";
import { getOffers, getOffer, createOffer, updateOffer, deleteOffer, getOfferAnalytics } from "../controllers/offerController.js";

const router = express.Router();

router.get("/analytics", authenticate, authorize("super_admin", "admin"), getOfferAnalytics);
router.get("/", authenticate, authorize("super_admin", "admin", "manager"), getOffers);
router.get("/:id", authenticate, authorize("super_admin", "admin", "manager"), getOffer);
router.post("/", authenticate, authorize("super_admin", "admin"), createOffer);
router.put("/:id", authenticate, authorize("super_admin", "admin"), updateOffer);
router.delete("/:id", authenticate, authorize("super_admin", "admin"), deleteOffer);

export default router;