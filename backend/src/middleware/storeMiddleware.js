import { resolveStoreId } from "../helpers/storeHelper.js";

export const storeMiddleware = (req, res, next) => {
  req.storeId = resolveStoreId(req.headers["x-store-id"], req.query.store_id);
  next();
};
