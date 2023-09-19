module.exports = {
  apps: [
    {
      name: 'api',
      script: './main.js',
      log_date_format: 'YYYY-MM-DD HH:mm Z',
      instances: 'max',
      exec_mode: 'cluster',
    },
  ],
};
