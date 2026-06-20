import { query } from "../config/db.js";
import { successResponse, errorResponse } from "../helpers/responseHelper.js";
import logger from "../config/logger.js";

// @desc    Get Dashboard Statistics
// @route   GET /api/dashboard/stats
export const getDashboardStats = async (req, res) => {
  try {
    const [aggregates] = await query(`
      SELECT
        (SELECT COUNT(*) FROM orders) AS totalOrders,
        (SELECT COUNT(*) FROM products WHERE status = 'active') AS totalProducts,
        (SELECT COUNT(*) FROM categories) AS totalCategories,
        (SELECT COUNT(*) FROM customers WHERE status = 'active') AS totalCustomers,
        (SELECT COUNT(*) FROM banners) AS totalBanners,
        (SELECT COUNT(*) FROM orders WHERE DATE(created_at) = CURDATE()) AS todayOrders,
        (SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE DATE(created_at) = CURDATE()) AS todayRevenue,
        (SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE MONTH(created_at) = MONTH(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE()) AND order_status = 'delivered') AS monthlyRevenue,
        (SELECT COUNT(*) FROM products WHERE stock <= low_stock_threshold AND stock > 0 AND status = 'active') AS lowStock,
        (SELECT COUNT(*) FROM products WHERE stock <= 0 AND status = 'active') AS outOfStock
    `);

    const [recentOrders, topProducts, monthlyRevenueData, orderStatusCounts] = await Promise.all([
      query(
        "SELECT id, order_number, customer_id, total_amount, order_status, payment_status, created_at FROM orders ORDER BY created_at DESC LIMIT 10"
      ),
      query(
        `SELECT p.id, p.name, p.thumbnail, p.price, p.total_sales, SUM(oi.quantity) as total_qty
         FROM products p
         JOIN order_items oi ON p.id = oi.product_id
         JOIN orders o ON oi.order_id = o.id
         WHERE o.order_status = 'delivered'
         GROUP BY p.id ORDER BY total_qty DESC LIMIT 10`
      ),
      query(
        `SELECT DATE_FORMAT(created_at, '%Y-%m') as month, COALESCE(SUM(total_amount), 0) as revenue, COUNT(*) as orders_count
         FROM orders WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) AND order_status = 'delivered'
         GROUP BY DATE_FORMAT(created_at, '%Y-%m') ORDER BY month ASC`
      ),
      query(
        "SELECT order_status, COUNT(*) as count FROM orders GROUP BY order_status"
      ),
    ]);

    return successResponse(res, {
      statistics: {
        totalOrders: aggregates.totalOrders,
        totalProducts: aggregates.totalProducts,
        totalCategories: aggregates.totalCategories,
        totalCustomers: aggregates.totalCustomers,
        totalBanners: aggregates.totalBanners,
        todayOrders: aggregates.todayOrders,
        todayRevenue: parseFloat(aggregates.todayRevenue),
        monthlyRevenue: parseFloat(aggregates.monthlyRevenue),
        lowStock: aggregates.lowStock,
        outOfStock: aggregates.outOfStock,
      },
      recentOrders,
      topProducts,
      revenueAnalytics: monthlyRevenueData,
      orderStatusDistribution: orderStatusCounts,
    });
  } catch (error) {
    logger.error("Dashboard stats error:", error);
    return errorResponse(res, "Failed to fetch dashboard statistics", 500);
  }
};

// @desc    Get Revenue Analytics
// @route   GET /api/dashboard/revenue
export const getRevenueAnalytics = async (req, res) => {
  try {
    const period = req.query.period || "monthly";

    let groupFormat, dateCondition;
    if (period === "daily") {
      groupFormat = "DATE_FORMAT(created_at, '%Y-%m-%d')";
      dateCondition = "created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)";
    } else if (period === "yearly") {
      groupFormat = "DATE_FORMAT(created_at, '%Y')";
      dateCondition = "created_at >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR)";
    } else {
      groupFormat = "DATE_FORMAT(created_at, '%Y-%m')";
      dateCondition = "created_at >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)";
    }

    const [revenue, totalRevenue, avgOrderValue] = await Promise.all([
      query(
        `SELECT ${groupFormat} as period, COALESCE(SUM(total_amount), 0) as revenue, COUNT(*) as orders_count FROM orders WHERE ${dateCondition} AND order_status = 'delivered' GROUP BY period ORDER BY period ASC`
      ),
      query("SELECT COALESCE(SUM(total_amount), 0) as total FROM orders WHERE order_status = 'delivered'"),
      query("SELECT COALESCE(AVG(total_amount), 0) as avg FROM orders WHERE order_status = 'delivered'"),
    ]);

    return successResponse(res, {
      revenue,
      totalRevenue: parseFloat(totalRevenue[0].total),
      averageOrderValue: parseFloat(avgOrderValue[0].avg),
    });
  } catch (error) {
    logger.error("Revenue analytics error:", error);
    return errorResponse(res, "Failed to fetch revenue analytics", 500);
  }
};

// @desc    Get Sales Analytics
// @route   GET /api/dashboard/sales
export const getSalesAnalytics = async (req, res) => {
  try {
    const [todaySales, weekSales, monthSales, salesByCategory] = await Promise.all([
      query("SELECT COALESCE(SUM(total_amount), 0) as total, COUNT(*) as orders FROM orders WHERE DATE(created_at) = CURDATE()"),
      query("SELECT COALESCE(SUM(total_amount), 0) as total, COUNT(*) as orders FROM orders WHERE WEEK(created_at) = WEEK(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE())"),
      query("SELECT COALESCE(SUM(total_amount), 0) as total, COUNT(*) as orders FROM orders WHERE MONTH(created_at) = MONTH(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE())"),
      query(
        "SELECT c.name, COUNT(oi.id) as total_sales, SUM(oi.total_price) as revenue FROM categories c JOIN products p ON c.id = p.category_id JOIN order_items oi ON p.id = oi.product_id JOIN orders o ON oi.order_id = o.id WHERE o.order_status = 'delivered' GROUP BY c.id ORDER BY revenue DESC LIMIT 10"
      ),
    ]);

    return successResponse(res, {
      today: { sales: parseFloat(todaySales[0].total), orders: todaySales[0].orders },
      thisWeek: { sales: parseFloat(weekSales[0].total), orders: weekSales[0].orders },
      thisMonth: { sales: parseFloat(monthSales[0].total), orders: monthSales[0].orders },
      salesByCategory,
    });
  } catch (error) {
    logger.error("Sales analytics error:", error);
    return errorResponse(res, "Failed to fetch sales analytics", 500);
  }
};

// @desc    Get Order Analytics
// @route   GET /api/dashboard/orders
export const getOrderAnalytics = async (req, res) => {
  try {
    const [statusCounts, paymentStatuses, monthlyOrders] = await Promise.all([
      query("SELECT order_status, COUNT(*) as count FROM orders GROUP BY order_status"),
      query("SELECT payment_status, COUNT(*) as count FROM orders GROUP BY payment_status"),
      query(
        "SELECT DATE_FORMAT(created_at, '%Y-%m') as month, COUNT(*) as total FROM orders WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) GROUP BY month ORDER BY month ASC"
      ),
    ]);

    return successResponse(res, {
      orderStatusDistribution: statusCounts,
      paymentStatusDistribution: paymentStatuses,
      monthlyOrders,
    });
  } catch (error) {
    logger.error("Order analytics error:", error);
    return errorResponse(res, "Failed to fetch order analytics", 500);
  }
};
