import api from "./api";

export const getBanners = () => api.get("/banners");

export const getBanner = (id) => api.get(`/banners/${id}`);

export const createBanner = (data) => api.post("/banners", data);

export const updateBanner = (id, data) => api.put(`/banners/${id}`, data);

export const deleteBanner = (id) => api.delete(`/banners/${id}`);
