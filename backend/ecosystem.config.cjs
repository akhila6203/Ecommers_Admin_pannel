module.exports = {
  apps: [{
    name: "lm-backend",
    script: "src/server.js",
    instances: 1,
    exec_mode: "fork",
    env: {
      NODE_ENV: "development",
    },
    env_production: {
      NODE_ENV: "production",
    },
    log_date_format: "YYYY-MM-DD HH:mm:ss Z",
    error_file: "logs/pm2-error.log",
    out_file: "logs/pm2-out.log",
    merge_logs: true,
    max_memory_restart: "500M",
    watch: false,
  }],
};