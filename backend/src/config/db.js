import mysql from "mysql2/promise";
import dotenv from "dotenv";
import logger from "./logger.js";

dotenv.config();

const pool = mysql.createPool({
  host: process.env.DB_HOST || "localhost",
  port: parseInt(process.env.DB_PORT) || 3306,
  database: process.env.DB_NAME || "lms",
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "",
  waitForConnections: true,
  connectionLimit: parseInt(process.env.DB_CONNECTION_LIMIT) || 10,
  queueLimit: 0,
  enableKeepAlive: true,
  keepAliveInitialDelay: 0,
});

export default pool;

export async function query(sql, params = []) {
  try {
    const [results] = await pool.execute(sql, params);
    return results;
  } catch (error) {
    logger.error("Database query error:", error);
    throw error;
  }
}

export async function getConnection() {
  try {
    const connection = await pool.getConnection();
    return connection;
  } catch (error) {
    logger.error("Database connection error:", error);
    throw error;
  }
}

export async function testConnection() {
  try {
    const connection = await pool.getConnection();
    logger.info("MySQL database connected successfully");
    connection.release();
    return true;
  } catch (error) {
    logger.error("MySQL database connection failed:", error.message);
    return false;
  }
}