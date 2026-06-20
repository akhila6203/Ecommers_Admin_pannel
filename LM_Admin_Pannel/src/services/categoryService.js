import api from "./api";

export const getCategories = () => api.get("/categories");

export const getCategory = (id) => api.get(`/categories/${id}`);

export const createCategory = (data) => api.post("/categories", data);

export const updateCategory = (id, data) => api.put(`/categories/${id}`, data);

export const deleteCategory = (id) => api.delete(`/categories/${id}`);

export const toggleCategoryStatus = (id) => api.put(`/categories/${id}/status`);

export const getSubCategories = (mainId) => api.get(`/categories/${mainId}/sub`);

export const createSubCategory = (data) => api.post("/categories/sub", data);

export const updateSubCategory = (id, data) => api.put(`/categories/sub/${id}`, data);

export const deleteSubCategory = (id) => api.delete(`/categories/sub/${id}`);

export const getChildCategories = (subId) => api.get(`/categories/sub/${subId}/child`);

export const createChildCategory = (data) => api.post("/categories/child", data);

export const updateChildCategory = (id, data) => api.put(`/categories/child/${id}`, data);

export const deleteChildCategory = (id) => api.delete(`/categories/child/${id}`);

export const getCategoryHierarchy = () => api.get("/categories/hierarchy");

export const getAllCategories = () => api.get("/categories/all");
