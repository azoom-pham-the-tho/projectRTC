const Vue = require("vue");
const renderer = require("vue-server-renderer").createRenderer();

exports.handler = async (event, context) => {
  console.log("Received event:", JSON.stringify(event, null, 2));

  const app = new Vue({
    template: "<div>Hello World!</div>",
  });

  const html = await renderer.renderToString(app);

  const response = {
    statusCode: 200,
    headers: {
      "Content-Type": "text/html",
    },
    body: html,
  };

  return response;
};
