const  Vue = require("vue");
const  renderer = require("vue-server-renderer");
const  App = require("./src/App.vue");
const  router = require ("./src/router");
const vuetify = require ("./src/plugins/vuetify");
renderer.createRenderer();
exports.handler = async (event, context) => {
  const app = new Vue({
    router,
    vuetify,
    render: (h) => h(App),
  }).$mount("#app");

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
