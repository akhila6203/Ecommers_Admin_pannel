import express from "express";
import { authenticate } from "../middleware/authMiddleware.js";
import { authorize } from "../middleware/roleMiddleware.js";
import {
  getSettings, getSettingsByGroup, updateSettings,
  updateSettingsByGroup, getPublicSettings,
  testEmailSettings, testShiprocketConnection,
} from "../controllers/settingController.js";
import {
  getStoreInformation,
  updateStoreInformation,
  getIntegrationSettings,
  updateIntegrationSettings,
  getAboutUsSettings,
  updateAboutUsSettings,
  getPrivacyPolicy,
  updatePrivacyPolicy,
  getTermsConditions,
  updateTermsConditions,
  getContactPage,
  updateContactPage,
} from "../controllers/settingsSectionController.js";

const router = express.Router();

// Public - store info
router.get("/public", getPublicSettings);

// Section-specific routes (must be before /:group)
router.get("/store-information", authenticate, authorize("super_admin", "admin"), getStoreInformation);
router.put("/store-information", authenticate, authorize("super_admin", "admin"), updateStoreInformation);

router.get("/integrations", authenticate, authorize("super_admin", "admin"), getIntegrationSettings);
router.put("/integrations", authenticate, authorize("super_admin", "admin"), updateIntegrationSettings);

router.get("/about-us", authenticate, authorize("super_admin", "admin"), getAboutUsSettings);
router.put("/about-us", authenticate, authorize("super_admin", "admin"), updateAboutUsSettings);

router.get("/privacy-policy", authenticate, authorize("super_admin", "admin"), getPrivacyPolicy);
router.put("/privacy-policy", authenticate, authorize("super_admin", "admin"), updatePrivacyPolicy);

router.get("/terms-conditions", authenticate, authorize("super_admin", "admin"), getTermsConditions);
router.put("/terms-conditions", authenticate, authorize("super_admin", "admin"), updateTermsConditions);

router.get("/contact-page", authenticate, authorize("super_admin", "admin"), getContactPage);
router.put("/contact-page", authenticate, authorize("super_admin", "admin"), updateContactPage);

// Protected generic routes
router.post("/test-email", authenticate, authorize("super_admin", "admin"), testEmailSettings);
router.post("/test-shiprocket", authenticate, authorize("super_admin", "admin"), testShiprocketConnection);
router.get("/", authenticate, authorize("super_admin", "admin"), getSettings);
router.put("/", authenticate, authorize("super_admin", "admin"), updateSettings);
router.get("/:group", authenticate, authorize("super_admin", "admin"), getSettingsByGroup);
router.put("/:group", authenticate, authorize("super_admin", "admin"), updateSettingsByGroup);

export default router;
