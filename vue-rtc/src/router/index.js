import Vue from "vue";
import VueRouter from "vue-router";
import ChatPage from "../views/ChatPage.vue";
import UserCall from "../views/UserCall.vue";
import GroupCall from "../views/GroupCall.vue";
import liveStream from "../views/LivePage.vue";
import LiveView from "../views/LiveView.vue";
import LoginPage from "../views/LoginPage.vue";
import RegisterPage from "../views/RegisterPage.vue";
Vue.use(VueRouter);

const routes = [
  {
    path: "/chat",
    name: "chat",
    component: ChatPage,
  },
  {
    path: "/login",
    name: "login",
    component: LoginPage,
  },
  {
    path: "/register",
    name: "register",
    component: RegisterPage,
  },
  {
    path: "/call/:id",
    name: "userCall",
    component: UserCall,
  },
  {
    path: "/live",
    name: "liveStream",
    component: liveStream,
  },
  {
    path: "/group/:id",
    name: "GroupCall",
    component: GroupCall,
  },
  {
    path: "/live/:id",
    name: "view live stream",
    component: LiveView,
  },
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes,
});

export default router;
