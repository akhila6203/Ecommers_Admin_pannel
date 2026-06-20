import api from "./api";

export const getCoupons = () => api.get("/coupons");

export const getCoupon = (id) => api.get(`/coupons/${id}`);
export const createCoupon = (data) => api.post("/coupons", data);

export const updateCoupon = (id, data) => api.put(`/coupons/${id}`, data);

export const deleteCoupon = (id) => api.delete(`/coupons/${id}`);

export const getCouponUsage = (id, params = {}) => api.get(`/coupons/${id}/usage`, { params });

export const getAllCouponUsage = (params = {}) => api.get("/coupons/usage/all", { params });

export const validateCoupon = (code, orderTotal) =>
  api.post("/coupons/validate", { code, order_amount: orderTotal });
