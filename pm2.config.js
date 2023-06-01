module.exports = {
  apps: [
    //note : config run
    {
      name: "nest",
      script: "npm",
      args: "run start:dev",
      cwd: "nest-server-rtc",
      instances: 1,
      exec_mode: "cluster",
      max_restarts: 10,
      min_uptime: 300,
      autorestart: true,
      watch: false,
      ignore_watch: ["node_modules"],
      max_memory_restart: "1G",
    },
    {
      name: "vue",
      script: "npm",
      args: "run serve",
      cwd: "vue-rtc",
      instances: 1,
      exec_mode: "cluster",
      max_restarts: 10,
      min_uptime: 300,
      autorestart: true,
      watch: false,
      ignore_watch: ["node_modules"],
      max_memory_restart: "1G",
    },
  ],
};
