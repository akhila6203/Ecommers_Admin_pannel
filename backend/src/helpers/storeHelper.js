export const DEFAULT_STORE_ID = 1;

export const getStoreId = (req) => {
  const id = req?.storeId ?? DEFAULT_STORE_ID;
  const parsed = parseInt(id, 10);
  return Number.isNaN(parsed) || parsed <= 0 ? DEFAULT_STORE_ID : parsed;
};

export const resolveStoreId = (headerValue, queryValue) => {
  if (headerValue !== undefined && headerValue !== null && headerValue !== "") {
    const parsed = parseInt(headerValue, 10);
    if (!Number.isNaN(parsed) && parsed > 0) return parsed;
  }
  if (queryValue !== undefined && queryValue !== null && queryValue !== "") {
    const parsed = parseInt(queryValue, 10);
    if (!Number.isNaN(parsed) && parsed > 0) return parsed;
  }
  return DEFAULT_STORE_ID;
};
