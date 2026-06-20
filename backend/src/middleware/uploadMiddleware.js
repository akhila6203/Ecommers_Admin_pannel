import multer from "multer";
import path from "path";
import fs from "fs";
import { fileURLToPath } from "url";
import { errorResponse } from "../helpers/responseHelper.js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    let uploadPath = path.join(__dirname, "../../uploads");

    const type = req.baseUrl.split("/").pop();
    if (type === "categories") uploadPath = path.join(uploadPath, "categories");
    else if (type === "products") uploadPath = path.join(uploadPath, "products");
    else if (type === "banners") uploadPath = path.join(uploadPath, "banners");
    else if (type === "media") uploadPath = path.join(uploadPath, "media");
    else if (type === "content") uploadPath = path.join(uploadPath, "content");
    else if (type === "admins" || type === "auth") uploadPath = path.join(uploadPath, "admins");

    if (!fs.existsSync(uploadPath)) {
      fs.mkdirSync(uploadPath, { recursive: true });
    }
    cb(null, uploadPath);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  },
});

const fileFilter = (req, file, cb) => {
  const allowedTypes = /jpeg|jpg|png|gif|webp|svg|pdf/;
  const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
  const mimetype = allowedTypes.test(file.mimetype);

  if (extname && mimetype) {
    cb(null, true);
  } else {
    cb(new Error("Only images (jpeg, jpg, png, gif, webp, svg) and PDF files are allowed"), false);
  }
};

export const upload = multer({
  storage,
  limits: {
    fileSize: parseInt(process.env.UPLOAD_MAX_SIZE) || 10 * 1024 * 1024,
  },
  fileFilter,
});

export const uploadErrorHandler = (err, req, res, next) => {
  if (err instanceof multer.MulterError) {
    if (err.code === "LIMIT_FILE_SIZE") {
      return errorResponse(res, "File too large. Maximum size is 10MB", 400);
    }
    return errorResponse(res, err.message, 400);
  }
  if (err) {
    return errorResponse(res, err.message, 400);
  }
  next();
};