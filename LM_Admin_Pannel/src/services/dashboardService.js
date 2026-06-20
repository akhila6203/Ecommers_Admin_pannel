import api from "./api";

export const getDashboardStats = () => api.get("/dashboard/stats");

export const getDashboardRevenue = (period = "monthly") =>
  api.get("/dashboard/revenue", { params: { period } });

export const getDashboardSales = (period = "monthly") =>
  api.get("/dashboard/sales", { params: { period } });

export const getDashboardOrders = (params = {}) => api.get("/dashboard/orders", { params });
