import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import mysql from "mysql2/promise";
import dotenv from "dotenv";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config({ path: path.join(__dirname, "../.env") });

async function runMigration() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST || "localhost",
    port: parseInt(process.env.DB_PORT) || 3306,
    user: process.env.DB_USER || "root",
    password: process.env.DB_PASSWORD || "",
    database: process.env.DB_NAME || "lms",
    multipleStatements: true,
  });

  try {
    const v4Path = path.join(__dirname, "v4_content_and_integrations.sql");
    const v4SQL = fs.readFileSync(v4Path, "utf8");
    console.log("Running V4 content_pages migration...");
    await connection.query(v4SQL);
    console.log("✓ V4 migration completed successfully");

    // Verify table exists
    const [rows] = await connection.query(
      "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = ? AND TABLE_NAME = 'content_pages'",
      [process.env.DB_NAME || "lms"]
    );
    console.log("Verified tables:", rows.map((r) => r.TABLE_NAME).join(", "));
  } catch (error) {
    console.error("Migration failed:", error.message);
    process.exit(1);
  } finally {
    await connection.end();
  }
}

runMigration();
