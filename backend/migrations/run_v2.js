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
    multipleStatements: true,
  });

  try {
    // Run V2 migration
    const v2Path = path.join(__dirname, "v2_product_module.sql");
    const v2SQL = fs.readFileSync(v2Path, "utf8");
    console.log("Running V2 product module migration...");
    await connection.query(v2SQL);
    console.log("✓ V2 migration completed successfully");

    // Verify tables exist
    const [rows] = await connection.query(
      "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'lms' AND TABLE_NAME IN ('product_seo', 'product_variant_options')"
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