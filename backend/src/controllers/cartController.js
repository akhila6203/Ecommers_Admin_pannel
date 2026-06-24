import { query } from "../config/db.js";
import { successResponse, errorResponse } from "../helpers/responseHelper.js";
import { getStoreId } from "../helpers/storeHelper.js";

const getSessionId = (req) =>
  req.headers["x-cart-session-id"] ||
  req.body.session_id ||
  req.query.session_id;

const safeJsonParse = (value, fallback = {}) => {
  try {
    if (!value) return fallback;
    if (typeof value === "object") return value;
    return JSON.parse(value);
  } catch {
    return fallback;
  }
};

export const getCart = async (req, res) => {
  try {
    const storeId = getStoreId(req);
    const sessionId = getSessionId(req);

    if (!sessionId) {
      return errorResponse(res, "Cart session id required", 400);
    }

    const rows = await query(
      `SELECT 
        c.id AS cart_id,
        c.product_id,
        c.variant_id,
        c.quantity AS qty,
        c.selected_size AS size,
        c.selected_color AS color,
        c.item_price,
        c.item_data,
        p.name,
        p.slug,
        p.price,
        p.offer_price,
        p.thumbnail,
        p.fabric,
        p.material,
        p.stock
      FROM cart c
      INNER JOIN products p 
        ON p.id = c.product_id 
       AND p.store_id = c.store_id
      WHERE c.store_id = ? 
        AND c.session_id = ?
      ORDER BY c.updated_at DESC`,
      [storeId, sessionId]
    );

    const cart = rows.map((row) => {
      const itemData = safeJsonParse(row.item_data, {});

      return {
        cartItemId: String(row.cart_id),
        cart_id: row.cart_id,

        id: row.product_id,
        product_id: row.product_id,
        variant_id: row.variant_id,

        slug: row.slug,
        name: row.name,

        qty: Number(row.qty || 1),
        size: row.size || itemData.selected_size || "Free Size",
        color: row.color || itemData.selected_color || "",

        price: Number(row.offer_price || row.price || row.item_price || 0),
        oldPrice: Number(row.price || 0),

        image: row.thumbnail,

        fabric: row.fabric || "",
        material: row.material || "",
        stock: Number(row.stock || 0),

        sizes: Array.isArray(itemData.sizes) ? itemData.sizes : [],
        colors: Array.isArray(itemData.colors) ? itemData.colors : [],
      };
    });

    return successResponse(res, cart, "Cart fetched successfully");
  } catch (error) {
    console.error("Get cart error:", error);
    return errorResponse(res, error.message || "Failed to fetch cart", 500);
  }
};

export const addToCart = async (req, res) => {
  try {
    const storeId = getStoreId(req);
    const sessionId = getSessionId(req);

    if (!sessionId) {
      return errorResponse(res, "Cart session id required", 400);
    }

    const {
      product_id,
      variant_id = null,
      quantity = 1,
      selected_size = null,
      selected_color = null,
      item_price = 0,
      item_data = null,
    } = req.body;

    if (!product_id) {
      return errorResponse(res, "Product id required", 400);
    }

    const productRows = await query(
      `SELECT id, price, offer_price, stock 
       FROM products 
       WHERE id = ? AND store_id = ?`,
      [product_id, storeId]
    );

    if (!productRows.length) {
      return errorResponse(res, "Product not found", 404);
    }

    const product = productRows[0];
    const finalPrice = Number(
      item_price || product.offer_price || product.price || 0
    );

    const qty = Math.max(1, Number(quantity) || 1);

    const jsonData =
      item_data && typeof item_data === "object"
        ? JSON.stringify(item_data)
        : item_data
        ? item_data
        : null;

    const existing = await query(
      `SELECT id, quantity 
       FROM cart
       WHERE store_id = ?
         AND session_id = ?
         AND product_id = ?
         AND COALESCE(variant_id, 0) = COALESCE(?, 0)
         AND COALESCE(selected_size, '') = COALESCE(?, '')
         AND COALESCE(selected_color, '') = COALESCE(?, '')
       LIMIT 1`,
      [
        storeId,
        sessionId,
        product_id,
        variant_id || null,
        selected_size || null,
        selected_color || null,
      ]
    );

    if (existing.length) {
      await query(
        `UPDATE cart 
         SET quantity = quantity + ?,
             item_price = ?,
             item_data = COALESCE(?, item_data),
             updated_at = NOW()
         WHERE id = ? 
           AND store_id = ? 
           AND session_id = ?`,
        [qty, finalPrice, jsonData, existing[0].id, storeId, sessionId]
      );
    } else {
      await query(
        `INSERT INTO cart
          (store_id, session_id, product_id, variant_id, quantity, selected_size, selected_color, item_price, item_data)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [
          storeId,
          sessionId,
          product_id,
          variant_id || null,
          qty,
          selected_size || null,
          selected_color || null,
          finalPrice,
          jsonData,
        ]
      );
    }

    return successResponse(res, null, "Added to cart");
  } catch (error) {
    console.error("Add cart error:", error);
    return errorResponse(res, error.message || "Failed to add cart", 500);
  }
};

export const updateCartItem = async (req, res) => {
  try {
    const storeId = getStoreId(req);
    const sessionId = getSessionId(req);
    const cartId = req.params.id;

    if (!sessionId) {
      return errorResponse(res, "Cart session id required", 400);
    }

    if (!cartId) {
      return errorResponse(res, "Cart item id required", 400);
    }

    const { quantity, selected_size, selected_color } = req.body;

    const fields = [];
    const values = [];

    if (quantity !== undefined) {
      fields.push("quantity = ?");
      values.push(Math.max(1, Number(quantity) || 1));
    }

    if (selected_size !== undefined) {
      fields.push("selected_size = ?");
      values.push(selected_size || null);
    }

    if (selected_color !== undefined) {
      fields.push("selected_color = ?");
      values.push(selected_color || null);
    }

    if (!fields.length) {
      return errorResponse(res, "Nothing to update", 400);
    }

    fields.push("updated_at = NOW()");

    const result = await query(
      `UPDATE cart 
       SET ${fields.join(", ")}
       WHERE id = ? 
         AND store_id = ? 
         AND session_id = ?`,
      [...values, cartId, storeId, sessionId]
    );

    if (result?.affectedRows === 0) {
      return errorResponse(res, "Cart item not found", 404);
    }

    return successResponse(res, null, "Cart updated");
  } catch (error) {
    console.error("Update cart error:", error);
    return errorResponse(res, error.message || "Failed to update cart", 500);
  }
};

export const removeCartItem = async (req, res) => {
  try {
    const storeId = getStoreId(req);
    const sessionId = getSessionId(req);
    const cartId = req.params.id;

    if (!sessionId) {
      return errorResponse(res, "Cart session id required", 400);
    }

    if (!cartId) {
      return errorResponse(res, "Cart item id required", 400);
    }

    const result = await query(
      `DELETE FROM cart 
       WHERE id = ? 
         AND store_id = ? 
         AND session_id = ?`,
      [cartId, storeId, sessionId]
    );

    if (result?.affectedRows === 0) {
      return errorResponse(res, "Cart item not found", 404);
    }

    return successResponse(res, null, "Cart item removed");
  } catch (error) {
    console.error("Remove cart error:", error);
    return errorResponse(res, error.message || "Failed to remove cart item", 500);
  }
};

export const clearCart = async (req, res) => {
  try {
    const storeId = getStoreId(req);
    const sessionId = getSessionId(req);

    if (!sessionId) {
      return errorResponse(res, "Cart session id required", 400);
    }

    await query(
      `DELETE FROM cart 
       WHERE store_id = ? 
         AND session_id = ?`,
      [storeId, sessionId]
    );

    return successResponse(res, null, "Cart cleared");
  } catch (error) {
    console.error("Clear cart error:", error);
    return errorResponse(res, error.message || "Failed to clear cart", 500);
  }
};