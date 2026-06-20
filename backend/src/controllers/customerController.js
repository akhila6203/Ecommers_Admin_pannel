import { query } from "../config/db.js";
import { hashPassword, comparePassword } from "../helpers/passwordHelper.js";
import { successResponse, errorResponse, paginatedResponse } from "../helpers/responseHelper.js";
import logger from "../config/logger.js";

// @desc    Get all customers
// @route   GET /api/customers
export const getCustomers = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const offset = (page - 1) * limit;
    const search = req.query.search || "";
    const status = req.query.status || "";
    const sort = req.query.sort || "created_at";
    const order = req.query.order || "DESC";

    let whereClause = "WHERE 1=1";
    const params = [];

    if (search) {
      whereClause += " AND (c.first_name LIKE ? OR c.last_name LIKE ? OR c.email LIKE ? OR c.phone LIKE ?)";
      params.push(`%${search}%`, `%${search}%`, `%${search}%`, `%${search}%`);
    }
    if (status) { whereClause += " AND c.status = ?"; params.push(status); }

    const allowedSorts = ["created_at", "first_name", "last_name", "email", "total_orders", "total_spent"];
    const sortColumn = allowedSorts.includes(sort) ? `c.${sort}` : "c.created_at";
    const sortOrder = order === "ASC" ? "ASC" : "DESC";

    const countResult = await query(`SELECT COUNT(*) as total FROM customers c ${whereClause}`, params);
    const total = countResult[0].total;

    const customers = await query(
      `SELECT c.*,
        (SELECT COUNT(*) FROM orders WHERE customer_id = c.id) as order_count,
        (SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE customer_id = c.id) as total_spent_amount
       FROM customers c ${whereClause}
       ORDER BY ${sortColumn} ${sortOrder}
       LIMIT ? OFFSET ?`,
      [...params, String(limit), String(offset)]
    );

    return paginatedResponse(res, customers, total, page, limit);
  } catch (error) {
    logger.error("Get customers error:", error);
    return errorResponse(res, "Failed to fetch customers", 500);
  }
};

// @desc    Get single customer
// @route   GET /api/customers/:id
export const getCustomer = async (req, res) => {
  try {
    const customers = await query("SELECT * FROM customers WHERE id = ?", [req.params.id]);
    if (!customers.length) return errorResponse(res, "Customer not found", 404);

    const customer = customers[0];
    customer.addresses = await query("SELECT * FROM customer_addresses WHERE customer_id = ?", [customer.id]);
    customer.orders = await query("SELECT id, order_number, total_amount, order_status, payment_status, created_at FROM orders WHERE customer_id = ? ORDER BY created_at DESC", [customer.id]);
    customer.reviews = await query("SELECT r.*, p.name as product_name FROM reviews r JOIN products p ON r.product_id = p.id WHERE r.customer_id = ? ORDER BY r.created_at DESC", [customer.id]);

    return successResponse(res, customer);
  } catch (error) {
    logger.error("Get customer error:", error);
    return errorResponse(res, "Failed to fetch customer", 500);
  }
};

// @desc    Create customer (admin)
// @route   POST /api/customers
export const createCustomer = async (req, res) => {
  try {
    const { first_name, last_name, email, password, phone, gender, date_of_birth } = req.body;
    const existing = await query("SELECT id FROM customers WHERE email = ?", [email]);
    if (existing.length) return errorResponse(res, "Email already registered", 409);

    const hashedPassword = await hashPassword(password);
    const result = await query(
      "INSERT INTO customers (first_name, last_name, email, password, phone, gender, date_of_birth) VALUES (?, ?, ?, ?, ?, ?, ?)",
      [first_name, last_name, email, hashedPassword, phone || null, gender || null, date_of_birth || null]
    );

    const customer = await query("SELECT id, first_name, last_name, email, phone FROM customers WHERE id = ?", [result.insertId]);
    return successResponse(res, customer[0], "Customer created successfully", 201);
  } catch (error) {
    logger.error("Create customer error:", error);
    return errorResponse(res, "Failed to create customer", 500);
  }
};

// @desc    Update customer
// @route   PUT /api/customers/:id
export const updateCustomer = async (req, res) => {
  try {
    const { first_name, last_name, phone, gender, date_of_birth, status, notes } = req.body;
    await query(
      "UPDATE customers SET first_name = COALESCE(?, first_name), last_name = COALESCE(?, last_name), phone = COALESCE(?, phone), gender = COALESCE(?, gender), date_of_birth = COALESCE(?, date_of_birth), status = COALESCE(?, status), notes = COALESCE(?, notes) WHERE id = ?",
      [first_name, last_name, phone, gender, date_of_birth, status, notes, req.params.id]
    );
    return successResponse(res, null, "Customer updated successfully");
  } catch (error) {
    logger.error("Update customer error:", error);
    return errorResponse(res, "Failed to update customer", 500);
  }
};

// @desc    Block/Unblock customer
// @route   PUT /api/customers/:id/block
export const blockCustomer = async (req, res) => {
  try {
    const customers = await query("SELECT id, status FROM customers WHERE id = ?", [req.params.id]);
    if (!customers.length) return errorResponse(res, "Customer not found", 404);
    const newStatus = customers[0].status === "blocked" ? "active" : "blocked";
    await query("UPDATE customers SET status = ? WHERE id = ?", [newStatus, req.params.id]);
    return successResponse(res, { status: newStatus }, `Customer ${newStatus === "blocked" ? "blocked" : "unblocked"} successfully`);
  } catch (error) {
    logger.error("Block customer error:", error);
    return errorResponse(res, "Failed to update customer status", 500);
  }
};

// @desc    Delete customer
// @route   DELETE /api/customers/:id
export const deleteCustomer = async (req, res) => {
  try {
    await query("DELETE FROM customers WHERE id = ?", [req.params.id]);
    return successResponse(res, null, "Customer deleted");
  } catch (error) {
    logger.error("Delete customer error:", error);
    return errorResponse(res, "Failed to delete customer", 500);
  }
};

// @desc    Get customer analytics
// @route   GET /api/customers/analytics
export const getCustomerAnalytics = async (req, res) => {
  try {
    const [total] = await query("SELECT COUNT(*) as total FROM customers");
    const [active] = await query("SELECT COUNT(*) as total FROM customers WHERE status = 'active'");
    const [blocked] = await query("SELECT COUNT(*) as total FROM customers WHERE status = 'blocked'");
    const [newThisMonth] = await query("SELECT COUNT(*) as total FROM customers WHERE MONTH(created_at) = MONTH(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE())");
    const [monthlyData] = await query(
      "SELECT DATE_FORMAT(created_at, '%Y-%m') as month, COUNT(*) as count FROM customers WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) GROUP BY month ORDER BY month"
    );

    return successResponse(res, {
      total: total[0].total,
      active: active[0].total,
      blocked: blocked[0].total,
      newThisMonth: newThisMonth[0].total,
      monthlyGrowth: monthlyData,
    });
  } catch (error) {
    logger.error("Customer analytics error:", error);
    return errorResponse(res, "Failed to fetch analytics", 500);
  }
};