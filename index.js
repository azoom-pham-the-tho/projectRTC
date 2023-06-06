const { execSync } = require("child_process");

exports.handler = async (event, context) => {
  try {
    // Chạy lệnh Docker Compose để khởi động các container Vue.js và Nest.js
    execSync("docker-compose up -d", { stdio: "inherit" });

    // Thực hiện các xử lý khác trong Lambda function của bạn

    return { statusCode: 200, body: "Lambda function executed successfully" };
  } catch (error) {
    console.error("Error executing Lambda function:", error);
    return { statusCode: 500, body: error };
  }
};
