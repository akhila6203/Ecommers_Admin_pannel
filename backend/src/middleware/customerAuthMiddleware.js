import { verifyToken } from "../helpers/jwtHelper.js";
import { errorResponse } from "../helpers/responseHelper.js";

export const authenticateCustomer = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return errorResponse(res, "Access denied. Login required", 401);
    }

    const token = authHeader.split(" ")[1];
    const decoded = verifyToken(token);

    if (!decoded?.id || decoded.role !== "customer") {
      return errorResponse(res, "Invalid customer token", 401);
    }

    req.customer = {
      id: decoded.id,
      email: decoded.email,
      storeId: decoded.storeId,
      firstName: decoded.firstName || "",
      lastName: decoded.lastName || "",
    };
    next();
  } catch (error) {
    if (error.name === "TokenExpiredError") {
      return errorResponse(res, "Session expired. Please login again", 401);
    }
    return errorResponse(res, "Invalid token", 401);
  }
};

export const optionalCustomerAuth = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (authHeader && authHeader.startsWith("Bearer ")) {
      const token = authHeader.split(" ")[1];
      const decoded = verifyToken(token);
      if (decoded?.id && decoded.role === "customer") {
        req.customer = {
          id: decoded.id,
          email: decoded.email,
          storeId: decoded.storeId,
          firstName: decoded.firstName || "",
          lastName: decoded.lastName || "",
        };
      }
    }
  } catch {
    // optional — guest cart still works
  }
  next();
};
