import api from "./api";

export const getBannerVideos = (params = {}) => api.get("/banner-videos", { params });

export const getBannerVideo = (id) => api.get(`/banner-videos/${id}`);

export const createBannerVideo = (data) => api.post("/banner-videos", data);

export const updateBannerVideo = (id, data) => api.put(`/banner-videos/${id}`, data);

export const deleteBannerVideo = (id) => api.delete(`/banner-videos/${id}`);
