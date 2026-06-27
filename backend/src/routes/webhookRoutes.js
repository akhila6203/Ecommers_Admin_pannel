import { Router } from "express";
import { handleShiprocketWebhook } from "../controllers/webhookController.js";

const router = Router();

router.post("/shiprocket", handleShiprocketWebhook);

export default router;
