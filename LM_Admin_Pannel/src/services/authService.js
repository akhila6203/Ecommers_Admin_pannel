import api from "./api";

export const login = (email, password) => api.post("/auth/login", { email, password });

export const logout = () => api.post("/auth/logout");

export const getProfile = () => api.get("/auth/profile");

export const updateProfile = (data) => api.put("/auth/profile", data);

export const changePassword = (data) => api.post("/auth/change-password", data);

export const refreshToken = (token) => api.post("/auth/refresh-token", { refreshToken: token });

export const forgotPassword = (email) => api.post("/auth/forgot-password", { email });

export const resetPassword = (data) => api.post("/auth/reset-password", data);
