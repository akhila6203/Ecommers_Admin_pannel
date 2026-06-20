import { errorResponse } from "../helpers/responseHelper.js";

export const authorize = (...allowedRoles) => {
  return (req, res, next) => {
    if (!req.admin) {
      return errorResponse(res, "Access denied. Not authenticated", 401);
    }
    if (!allowedRoles.includes(req.admin.role)) {
      return errorResponse(res, "Access denied. Insufficient permissions", 403);
    }
    next();
  };
};