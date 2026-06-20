import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import dotenv from "dotenv";
import mysql from "mysql2/promise";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: path.join(__dirname, "../.env") });

async function run() {
  const sql = fs.readFileSync(path.join(__dirname, "v3_performance_indexes.sql"), "utf8");
  const statements = sql
    .split(";")
    .map((s) => s.trim())
    .filter(Boolean);

  const conn = await mysql.createConnection({
    host: process.env.DB_HOST || "localhost",
    user: process.env.DB_USER || "root",
    password: process.env.DB_PASSWORD || "",
    database: process.env.DB_NAME || "lm_shopping_mall",
    port: parseInt(process.env.DB_PORT, 10) || 3306,
    multipleStatements: true,
  });

  console.log("Applying performance indexes...");
  for (const stmt of statements) {
    try {
      await conn.query(stmt);
      console.log("✓", stmt.split("\n")[0].slice(0, 80));
    } catch (err) {
      if (err.code === "ER_DUP_KEYNAME") {
        console.log("— index already exists, skipping");
      } else {
        console.error("✗", err.message);
      }
    }
  }
  await conn.end();
  console.log("Done.");
}

run().catch((e) => {
  console.error(e);
  process.exit(1);
});
