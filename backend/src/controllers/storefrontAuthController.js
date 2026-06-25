import { query } from "../config/db.js";
import { generateToken, generateRefreshToken } from "../helpers/jwtHelper.js";
import { hashPassword, comparePassword } from "../helpers/passwordHelper.js";
import { successResponse, errorResponse } from "../helpers/responseHelper.js";
import { getStoreId } from "../helpers/storeHelper.js";
import { getSessionId, mergeSessionCartToCustomer } from "../helpers/cartHelper.js";
import logger from "../config/logger.js";

const customerFields =
  "id, store_id, first_name, last_name, email, phone, avatar, gender, date_of_birth, status, total_orders, total_spent, address_line1, address_line2, city, state, pincode, country, created_at, last_login_at";

const buildCustomerPayload = (customer) => ({
  id: customer.id,
  store_id: customer.store_id,
  first_name: customer.first_name,
  last_name: customer.last_name,
  email: customer.email,
  phone: customer.phone,
  avatar: customer.avatar,
  gender: customer.gender,
  date_of_birth: customer.date_of_birth,
  status: customer.status,
  total_orders: customer.total_orders,
  total_spent: customer.total_spent,
  address: {
    address_line1: customer.address_line1,
    address_line2: customer.address_line2,
    city: customer.city,
    state: customer.state,
    pincode: customer.pincode,
    country: customer.country,
  },
  created_at: customer.created_at,
  last_login_at: customer.last_login_at,
});

const issueTokens = async (customer) => {
  const tokenPayload = {
    id: customer.id,
    email: customer.email,
    role: "customer",
    storeId: customer.store_id,
    firstName: customer.first_name,
    lastName: customer.last_name,
  };

  const token = generateToken(tokenPayload, "7d");
  const refreshToken = generateRefreshToken(tokenPayload);

  await query(
    "INSERT INTO refresh_tokens (customer_id, token, expires_at, created_at) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 7 DAY), NOW())",
    [customer.id, refreshToken]
  );

  return { token, refreshToken };
};

export const register = async (req, res) => {
  try {
    const storeId = getStoreId(req);
    const {
      first_name,
      last_name,
      email,
      password,
      phone,
      gender,
      date_of_birth,
      address_line1,
      address_line2,
      city,
      state,
      pincode,
      country,
    } = req.body;

    if (!first_name?.trim() || !last_name?.trim() || !email?.trim() || !password) {
      return errorResponse(res, "First name, last name, email and password are required", 400);
    }

    const existing = await query(
      "SELECT id FROM customers WHERE email = ? AND store_id = ?",
      [email.trim().toLowerCase(), storeId]
    );
    if (existing.length) {
      return errorResponse(res, "Email already registered", 409);
    }

    const hashedPassword = await hashPassword(password);
    const result = await query(
      `INSERT INTO customers
        (store_id, first_name, last_name, email, password, phone, gender, date_of_birth,
         address_line1, address_line2, city, state, pincode, country, status)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'active')`,
      [
        storeId,
        first_name.trim(),
        last_name.trim(),
        email.trim().toLowerCase(),
        hashedPassword,
        phone || null,
        gender || null,
        date_of_birth || null,
        address_line1 || null,
        address_line2 || null,
        city || null,
        state || null,
        pincode || null,
        country || "India",
      ]
    );

    const customers = await query(
      `SELECT ${customerFields} FROM customers WHERE id = ? AND store_id = ?`,
      [result.insertId, storeId]
    );
    const customer = customers[0];

    const sessionId = getSessionId(req);
    if (sessionId) {
      await mergeSessionCartToCustomer(storeId, sessionId, customer.id);
    }

    const { token, refreshToken } = await issueTokens(customer);

    return successResponse(
      res,
      { customer: buildCustomerPayload(customer), token, refreshToken },
      "Registration successful",
      201
    );
  } catch (error) {
    logger.error("Customer register error:", error);
    return errorResponse(res, "Registration failed", 500);
  }
};

export const login = async (req, res) => {
  try {
    const storeId = getStoreId(req);
    const { email, password } = req.body;

    if (!email?.trim() || !password) {
      return errorResponse(res, "Email and password are required", 400);
    }

    const customers = await query(
      `SELECT id, store_id, first_name, last_name, email, password, phone, avatar, gender,
              date_of_birth, status, total_orders, total_spent,
              address_line1, address_line2, city, state, pincode, country, created_at, last_login_at
       FROM customers WHERE email = ? AND store_id = ?`,
      [email.trim().toLowerCase(), storeId]
    );

    if (!customers.length) {
      return errorResponse(res, "Invalid email or password", 401);
    }

    const customer = customers[0];

    if (customer.status === "blocked") {
      return errorResponse(res, "Your account has been blocked. Contact support.", 403);
    }
    if (customer.status === "inactive") {
      return errorResponse(res, "Your account is inactive", 403);
    }

    const isMatch = await comparePassword(password, customer.password);
    if (!isMatch) {
      return errorResponse(res, "Invalid email or password", 401);
    }

    await query(
      "UPDATE customers SET last_login_at = NOW() WHERE id = ? AND store_id = ?",
      [customer.id, storeId]
    );

    const sessionId = getSessionId(req);
    if (sessionId) {
      await mergeSessionCartToCustomer(storeId, sessionId, customer.id);
    }

    await query(
      "UPDATE refresh_tokens SET revoked_at = NOW() WHERE customer_id = ? AND revoked_at IS NULL",
      [customer.id]
    );

    const { token, refreshToken } = await issueTokens(customer);

    return successResponse(res, {
      customer: buildCustomerPayload(customer),
      token,
      refreshToken,
    }, "Login successful");
  } catch (error) {
    logger.error("Customer login error:", error);
    return errorResponse(res, "Login failed", 500);
  }
};

export const logout = async (req, res) => {
  try {
    if (req.customer?.id) {
      await query(
        "UPDATE refresh_tokens SET revoked_at = NOW() WHERE customer_id = ? AND revoked_at IS NULL",
        [req.customer.id]
      );
    }
    return successResponse(res, null, "Logged out successfully");
  } catch (error) {
    logger.error("Customer logout error:", error);
    return errorResponse(res, "Logout failed", 500);
  }
};

export const getProfile = async (req, res) => {
  try {
    const storeId = getStoreId(req);
    const customers = await query(
      `SELECT ${customerFields} FROM customers WHERE id = ? AND store_id = ?`,
      [req.customer.id, storeId]
    );
    if (!customers.length) return errorResponse(res, "Customer not found", 404);

    const customer = customers[0];
    customer.addresses = await query(
      "SELECT * FROM customer_addresses WHERE customer_id = ? AND store_id = ? ORDER BY is_default DESC, created_at DESC",
      [customer.id, storeId]
    );

    const cartCountRows = await query(
      "SELECT COUNT(*) as count FROM cart WHERE customer_id = ? AND store_id = ?",
      [customer.id, storeId]
    );
    const wishlistCountRows = await query(
      "SELECT COUNT(*) as count FROM wishlists WHERE customer_id = ? AND store_id = ?",
      [customer.id, storeId]
    );

    return successResponse(res, {
      ...buildCustomerPayload(customer),
      addresses: customer.addresses,
      cart_count: cartCountRows[0].count,
      wishlist_count: wishlistCountRows[0].count,
    });
  } catch (error) {
    logger.error("Get customer profile error:", error);
    return errorResponse(res, "Failed to fetch profile", 500);
  }
};

export const updateProfile = async (req, res) => {
  try {
    const storeId = getStoreId(req);
    const {
      first_name,
      last_name,
      phone,
      gender,
      date_of_birth,
      address_line1,
      address_line2,
      city,
      state,
      pincode,
      country,
    } = req.body;

    await query(
      `UPDATE customers SET
        first_name = COALESCE(?, first_name),
        last_name = COALESCE(?, last_name),
        phone = COALESCE(?, phone),
        gender = COALESCE(?, gender),
        date_of_birth = COALESCE(?, date_of_birth),
        address_line1 = COALESCE(?, address_line1),
        address_line2 = COALESCE(?, address_line2),
        city = COALESCE(?, city),
        state = COALESCE(?, state),
        pincode = COALESCE(?, pincode),
        country = COALESCE(?, country)
       WHERE id = ? AND store_id = ?`,
      [
        first_name,
        last_name,
        phone,
        gender,
        date_of_birth,
        address_line1,
        address_line2,
        city,
        state,
        pincode,
        country,
        req.customer.id,
        storeId,
      ]
    );

    const customers = await query(
      `SELECT ${customerFields} FROM customers WHERE id = ? AND store_id = ?`,
      [req.customer.id, storeId]
    );

    return successResponse(res, buildCustomerPayload(customers[0]), "Profile updated");
  } catch (error) {
    logger.error("Update customer profile error:", error);
    return errorResponse(res, "Failed to update profile", 500);
  }
};
