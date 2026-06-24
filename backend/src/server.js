import express from "express";
import cors from "cors";
import helmet from "helmet";
import dotenv from "dotenv";
import path from "path";
import { fileURLToPath } from "url";
import { testConnection } from "./config/db.js";
import { storeMiddleware } from "./middleware/storeMiddleware.js";
import logger from "./config/logger.js";
import { apiLimiter } from "./middleware/rateLimiterMiddleware.js";
import { sanitizeMiddleware } from "./helpers/sanitizeHelper.js";
import { errorHandler, notFoundHandler } from "./middleware/errorMiddleware.js";

// Import Routes
import authRoutes from "./routes/authRoutes.js";
import dashboardRoutes from "./routes/dashboardRoutes.js";
import categoryRoutes from "./routes/categoryRoutes.js";
import productRoutes from "./routes/productRoutes.js";
import orderRoutes from "./routes/orderRoutes.js";
import customerRoutes from "./routes/customerRoutes.js";
import couponRoutes from "./routes/couponRoutes.js";
import offerRoutes from "./routes/offerRoutes.js";
import bannerRoutes from "./routes/bannerRoutes.js";
import collectionRoutes from "./routes/collectionRoutes.js";
import settingRoutes from "./routes/settingRoutes.js";
import contentRoutes from "./routes/contentRoutes.js";
import reportRoutes from "./routes/reportRoutes.js";
import notificationRoutes from "./routes/notificationRoutes.js";
import mediaRoutes from "./routes/mediaRoutes.js";
import adminRoutes from "./routes/adminRoutes.js";
import storeRoutes from "./routes/storeRoutes.js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config();

const app = express();
const PORT = parseInt(process.env.PORT, 10) || 5000;

// Security Middleware
app.use(helmet({
  crossOriginResourcePolicy: { policy: "cross-origin" },
  crossOriginOpenerPolicy: { policy: "same-origin-allow-popups" },
}));

// CORS Configuration — allow multiple frontend origins
const allowedOrigins = [
  "http://localhost:8080",
  "http://localhost:8081",
  "http://localhost:3000",
  "http://localhost:5173",
  process.env.FRONTEND_URL,
].filter(Boolean);

app.use(cors({
  origin: (origin, callback) => {
    // Allow requests with no origin (curl, mobile apps, etc.)
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error(`Origin ${origin} not allowed by CORS`));
    }
  },
  credentials: true,
  methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization", "X-Requested-With", "X-Store-Id"],
}));

// Body Parsers
app.use(express.json({ limit: "50mb" }));
app.use(express.urlencoded({ extended: true, limit: "50mb" }));

// Request Logging
app.use((req, res, next) => {
  logger.info(`${req.method} ${req.originalUrl}`);
  next();
});

// Global rate limiting — all environments (higher limit in development)
app.use(apiLimiter);
app.use(sanitizeMiddleware);
app.use(storeMiddleware);

// Static Files (Uploads)
app.use("/uploads", express.static(path.join(__dirname, "../uploads")));

// API Routes
app.use("/api/auth", authRoutes);
app.use("/api/dashboard", dashboardRoutes);
app.use("/api/categories", categoryRoutes);
app.use("/api/products", productRoutes);
app.use("/api/orders", orderRoutes);
app.use("/api/customers", customerRoutes);
app.use("/api/coupons", couponRoutes);
app.use("/api/offers", offerRoutes);
app.use("/api/banners", bannerRoutes);
app.use("/api/collections", collectionRoutes);
app.use("/api/settings", settingRoutes);
app.use("/api/content", contentRoutes);
app.use("/api/reports", reportRoutes);
app.use("/api/notifications", notificationRoutes);
app.use("/api/media", mediaRoutes);
app.use("/api/admin", adminRoutes);
app.use("/api/stores", storeRoutes);

// Health Check
app.get("/api/health", (req, res) => {
  res.status(200).json({
    success: true,
    message: "LM Shopping Mall API Running",
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || "development",
  });
});

// Root Route
app.get("/", (req, res) => {
  res.json({
    success: true,
    message: "LM Shopping Mall Backend API",
    version: "1.0.0",
    docs: "/api/docs",
  });
});

// Error Handling
app.use(notFoundHandler);
app.use(errorHandler);

// ========== GLOBAL UNHANDLED REJECTION HANDLER ==========
process.on("unhandledRejection", (reason, promise) => {
  logger.error("Unhandled Rejection at:", promise, "reason:", reason);
  // Log but do NOT exit — let the server continue running
});

process.on("uncaughtException", (error) => {
  logger.error("Uncaught Exception:", error);
  // Give the logger time to flush, then exit gracefully
  setTimeout(() => process.exit(1), 1000);
});

// ========== START SERVER ==========
async function startServer() {
  console.log("Starting LM Shopping Mall Backend...");
  console.log(`Port: ${PORT}, Environment: ${process.env.NODE_ENV || "development"}`);
  console.log("Connecting to MySQL...");

  const dbConnected = await testConnection();

  if (!dbConnected) {
    console.error("ERROR: Could not connect to MySQL database. Check your .env configuration.");
    logger.error("Server startup failed — database connection could not be established");
    process.exit(1);
  }

  console.log("MySQL database connected successfully");

  app.listen(PORT, () => {
    const startupMsg = `Server running on port ${PORT}`;
    console.log(startupMsg);
    logger.info(`✓ ${process.env.APP_NAME || "LM Shopping Mall"} backend running on port ${PORT}`);
    logger.info(`  Environment: ${process.env.NODE_ENV || "development"}`);
    logger.info(`  Frontend URL: ${process.env.FRONTEND_URL || "http://localhost:5173"}`);
    logger.info(`  API Base: http://localhost:${PORT}/api`);
  }).on("error", (err) => {
    if (err.code === "EADDRINUSE") {
      const msg = `Port ${PORT} is already in use. Please stop the other process or change PORT in .env`;
      console.error(`ERROR: ${msg}`);
      logger.error(msg);
    } else {
      console.error("ERROR: Failed to start server:", err.message);
      logger.error("Failed to start server:", err);
    }
    process.exit(1);
  });
}

if (process.env.NODE_ENV !== "test") {
  startServer();
}

export default app;