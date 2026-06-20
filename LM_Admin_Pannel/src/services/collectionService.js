import api from "./api";

export const getCollections = (params = {}) => api.get("/collections", { params });

export const getCollection = (id) => api.get(`/collections/${id}`);

export const createCollection = (data) => {
  const isFormData = data instanceof FormData;
  return api.post("/collections", data, {
    headers: isFormData ? { "Content-Type": "multipart/form-data" } : undefined,
  });
};

export const updateCollection = (id, data) => {
  const isFormData = data instanceof FormData;
  return api.put(`/collections/${id}`, data, {
    headers: isFormData ? { "Content-Type": "multipart/form-data" } : undefined,
  });
};

export const deleteCollection = (id) => api.delete(`/collections/${id}`);
