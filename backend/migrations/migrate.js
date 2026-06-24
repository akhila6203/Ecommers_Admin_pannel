import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import mysql from "mysql2/promise";
import dotenv from "dotenv";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config({ path: path.join(__dirname, "../.env") });

const MIGRATION_FILES = fs
  .readdirSync(__dirname)
  .filter((f) => /^\d{2}_.*\.sql$/.test(f))
  .sort()
  .filter((f) => f !== "14_sync_old_database.sql");

// Sync old DB schema (store_id, missing columns) before content/settings inserts
const SYNC_FILE = "14_sync_old_database.sql";
const firstContentIdx = MIGRATION_FILES.findIndex((f) => f >= "10_");
if (firstContentIdx >= 0) {
  MIGRATION_FILES.splice(firstContentIdx, 0, SYNC_FILE);
} else {
  MIGRATION_FILES.push(SYNC_FILE);
}

async function runMigrations() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST || "localhost",
    port: parseInt(process.env.DB_PORT, 10) || 3306,
    user: process.env.DB_USER || "root",
    password: process.env.DB_PASSWORD || "",
    multipleStatements: true,
  });

  try {
    console.log("Connected to MySQL server");

    for (const file of MIGRATION_FILES) {
      const sqlPath = path.join(__dirname, file);
      const sql = fs.readFileSync(sqlPath, "utf8");
      console.log(`Running ${file}...`);
      await connection.query(sql);
      console.log(`✓ ${file}`);
    }

    console.log("All migrations completed successfully");
  } catch (error) {
    console.error("Migration failed:", error.message);
    process.exit(1);
  } finally {
    await connection.end();
  }
}

runMigrations();
