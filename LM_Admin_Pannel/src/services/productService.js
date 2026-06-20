import api from "./api";

export const getProducts = (params = {}) => api.get("/products", { params });

export const getProduct = (id) => api.get(`/products/${id}`);

export const createProduct = (data) => api.post("/products", data);

export const updateProduct = (id, data) => api.put(`/products/${id}`, data);

export const deleteProduct = (id) => api.delete(`/products/${id}`);

export const bulkDeleteProducts = (ids) => api.post("/products/bulk-delete", { ids });

export const toggleFeatured = (id) => api.put(`/products/${id}/featured`);

export const toggleTrending = (id) => api.put(`/products/${id}/trending`);

export const toggleBestSeller = (id) => api.put(`/products/${id}/best-seller`);

export const updateProductStatus = (id, status) => api.put(`/products/${id}/status`, { status });

export const updateStock = (id, stock) => api.put(`/products/${id}/stock`, { stock });

export const getVariantOptions = (productId) => api.get(`/products/${productId}/variant-options`);

export const createVariantOption = (productId, data) =>
  api.post(`/products/${productId}/variant-options`, data);

export const updateVariantOption = (productId, optionId, data) =>
  api.put(`/products/${productId}/variant-options/${optionId}`, data);

export const deleteVariantOption = (productId, optionId) =>
  api.delete(`/products/${productId}/variant-options/${optionId}`);

export const generateVariantCombinations = (productId) =>
  api.post(`/products/${productId}/variant-combinations/generate`);

export const updateVariant = (productId, variantId, data) =>
  api.put(`/products/${productId}/variants/${variantId}`, data);

export const deleteVariant = (productId, variantId) =>
  api.delete(`/products/${productId}/variants/${variantId}`);

export const getProductSeo = (productId) => api.get(`/products/${productId}/seo`);

export const updateProductSeo = (productId, data) => api.put(`/products/${productId}/seo`, data);
