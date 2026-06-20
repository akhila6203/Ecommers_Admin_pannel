import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import mysql from "mysql2/promise";
import dotenv from "dotenv";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config({ path: path.join(__dirname, "../.env") });

async function tableExists(connection, dbName, tableName) {
  const [rows] = await connection.query(
    "SELECT COUNT(*) AS cnt FROM information_schema.tables WHERE table_schema = ? AND table_name = ?",
    [dbName, tableName]
  );
  return rows[0].cnt > 0;
}

async function main() {
  const dbName = process.env.DB_NAME || "lms";
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST || "localhost",
    port: parseInt(process.env.DB_PORT, 10) || 3306,
    user: process.env.DB_USER || "root",
    password: process.env.DB_PASSWORD || "",
    database: dbName,
    multipleStatements: true,
  });

  try {
    const hasContentPages = await tableExists(connection, dbName, "content_pages");
    const hasSettingsIntegrations = await tableExists(connection, dbName, "settings_integrations");

    console.log(`content_pages exists: ${hasContentPages}`);
    console.log(`settings_integrations exists: ${hasSettingsIntegrations}`);

    if (hasContentPages && hasSettingsIntegrations) {
      console.log("Both tables already exist. Running idempotent v4 SQL (seeds + banner path fix only).");
    } else {
      console.log("Missing table(s). Running full v4 migration...");
    }

    const sqlPath = path.join(__dirname, "../migrations/v4_content_and_integrations.sql");
    const sql = fs.readFileSync(sqlPath, "utf8");
    await connection.query(sql);

    const [pages] = await connection.query("SELECT page_key, title FROM content_pages ORDER BY page_key");
    console.log("content_pages rows:", pages.length);
    pages.forEach((p) => console.log(`  - ${p.page_key}: ${p.title}`));

    const [settings] = await connection.query("SELECT COUNT(*) AS cnt FROM settings_integrations");
    console.log(`settings_integrations rows: ${settings[0].cnt}`);
    console.log("v4 migration completed successfully.");
  } finally {
    await connection.end();
  }
}

main().catch((err) => {
  console.error("Migration failed:", err.message);
  process.exit(1);
});
