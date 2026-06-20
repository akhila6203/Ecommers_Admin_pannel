# Fix Report

**Date:** 2026-06-17  
**Project:** LM Shopping Mall — Admin Panel (React + Node.js + MySQL)

---

## Files Modified

### Frontend Files
| File | Changes |
|------|---------|
| `LM_Admin_Pannel/src/services/api.js` | Strip `Content-Type` for FormData so multer receives correct multipart boundary |
| `LM_Admin_Pannel/src/utils/imageUrl.js` | **New** — shared `resolveUploadUrl()` + placeholder fallback |
| `LM_Admin_Pannel/src/services/bannerService.js` | Removed manual multipart headers (axios handles via interceptor) |
| `LM_Admin_Pannel/src/services/productService.js` | Removed manual multipart headers |
| `LM_Admin_Pannel/src/services/couponService.js` | Restored `getCoupons()` export |
| `LM_Admin_Pannel/src/services/settingsService.js` | Removed manual multipart headers for content/upload |
| `LM_Admin_Pannel/src/services/index.js` | Removed `reviewService` export |
| `LM_Admin_Pannel/src/pages/Gallery.jsx` | Uses `resolveUploadUrl()` + placeholder on image error |
| `LM_Admin_Pannel/src/pages/Offers.jsx` | Edit loads full coupon via `getCoupon()`; preserves limits on update; safer date parsing |
| `LM_Admin_Pannel/src/pages/AddProduct.jsx` | Category IDs only sent when set; image URLs via `resolveUploadUrl()` |
| `LM_Admin_Pannel/src/pages/Conditions.jsx` | About image URL via `resolveUploadUrl()` |

### Frontend Files Removed
| File | Reason |
|------|--------|
| `LM_Admin_Pannel/src/pages/Reviews.jsx` | Phase 2 — Reviews module removed |
| `LM_Admin_Pannel/src/services/reviewService.js` | Phase 2 — Reviews module removed |

### Backend Files
| File | Changes |
|------|---------|
| `backend/src/helpers/imagePathHelper.js` | **New** — normalize legacy banner paths in API responses |
| `backend/src/controllers/bannerController.js` | Returns normalized image paths on GET |
| `backend/src/controllers/couponController.js` | Fixed `expiry_date ?? null` on create; nullish-safe update (preserves 0% discounts & existing limits) |
| `backend/src/controllers/productController.js` | Safe category FK coercion; clear child when sub cleared; fix thumbnail detection via `product_images` query |

### Backend Files Removed
| File | Reason |
|------|--------|
| `backend/src/routes/reviewRoutes.js` | Phase 2 — Reviews module removed |
| `backend/src/controllers/reviewController.js` | Phase 2 — Reviews module removed |

### Database Changes
| File | Changes |
|------|---------|
| `backend/migrations/v4_content_and_integrations.sql` | Added `settings_integrations` table, content page seeds, legacy banner path normalization SQL |

**Run migration manually:**
```powershell
Get-Content backend\migrations\v4_content_and_integrations.sql | mysql -u root lms
```

---

## New APIs (already wired — no duplicates created)

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/content/:page_key` | Load About, Contact, Privacy, Terms, Shipping, Refund |
| PUT | `/api/content/:page_key` | Update content page (multipart for About image) |
| POST | `/api/settings/test-email` | Test SMTP settings |
| POST | `/api/settings/test-shiprocket` | Test Shiprocket connection |

Existing settings group APIs (`/api/settings/integrations` via `getSettingsByGroup`) continue to power Store Settings → Integrations tab.

---

## Issues Fixed

✓ **Gallery images** — FormData upload fix + URL normalization for legacy paths + placeholder fallback  
✓ **Coupon edit** — Full coupon fetch on edit; backend preserves existing fields on partial update  
✓ **Product edit** — FK-safe category IDs; correct thumbnail handling; multipart upload fix  
✓ **Conditions page** — Sidebar menu, route, 6 tabs with editors + live preview  
✓ **About Us redesign** — Title + rich text + image + live preview via `/api/content/about`  
✓ **Contact page** — Structured fields + preview via `/api/content/contact`  
✓ **Privacy Policy** — Title + rich text + preview  
✓ **Terms & Conditions** — Title + rich text + preview  
✓ **Shipping Policy** — Title + rich text + preview  
✓ **Refund Policy** — Title + rich text + preview  
✓ **Payment Gateway settings** — Razorpay, Stripe, COD in Store Settings → Integrations  
✓ **Shiprocket settings** — With test connection button  
✓ **Reviews module removed** — Frontend pages/services + backend routes/controllers (DB table kept)  

---

## Root Causes Identified

1. **Image uploads broken:** Axios default `Content-Type: application/json` was sent with FormData, preventing multer from parsing files. Fixed globally in `api.js` request interceptor.
2. **Gallery legacy paths:** Seed data stored bare filenames (`placeholder.svg`). Fixed via backend normalization + frontend `resolveUploadUrl()`.
3. **Coupon edit empty:** Update payload was resetting `usage_limit` etc. to 0; edit now fetches full record and only sends changed fields.
4. **Product edit FK error:** Empty/invalid `child_category_id` sent on update. Backend now coerces IDs safely and clears child when sub-category is absent.

---

## API Verification

| Module | GET | POST | PUT | DELETE | Status |
|--------|-----|------|-----|--------|--------|
| Gallery/Banners | ✓ | ✓ | ✓ | ✓ | Fixed |
| Coupons | ✓ | ✓ | ✓ | ✓ | Fixed |
| Products | ✓ | ✓ | ✓ | ✓ | Fixed |
| Conditions/Content | ✓ | — | ✓ | — | Working |
| Store Settings | ✓ | test-* | ✓ | — | Working |
| Reviews | — | — | — | — | Removed |

**Backend Jest suite:** 15/15 tests passed (`npm test` in `backend/`).

---

## Remaining Issues

1. **Run v4 migration** on your MySQL instance if `content_pages` / `settings_integrations` tables are not yet created.
2. **Manual UI smoke test** recommended: upload a new banner, edit a coupon, edit a product with category change, save each Conditions tab.
3. **`AboutUsPageBuilder.jsx`** still exists for Store Settings logo upload helper — not used for Conditions content (intentional separation).

---

## Quick Test Checklist

- [ ] Gallery: existing images display; new upload shows immediately
- [ ] Coupons: Edit populates code, discount, dates, status; Update persists
- [ ] Products: Edit loads data + images; Update saves to MySQL
- [ ] Conditions: All 6 tabs load/save independently
- [ ] Store Settings → Integrations: Save + Test Email + Test Shiprocket
