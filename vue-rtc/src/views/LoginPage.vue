<template>
  <div id="app">
    <form class="form" @submit.prevent="loginWithPassword">
      <h1>LOGIN</h1>
      <v-text-field
        class="input"
        v-model="name"
        label="Username"
        hide-details="auto"
      >
      </v-text-field>
      <v-text-field
        class="input"
        v-model="pass"
        label="Password"
        hide-details="auto"
      >
      </v-text-field>
      <div class="btn-submit">
        <v-btn outlined @click="login" small> Log in </v-btn>
      </div>
      <div class="btn-register" @click="register">register user</div>
    </form>
  </div>
</template>

<script>
import axiosClient from "@/config/axiosClient";
export default {
  data() {
    return {
      name: "",
      pass: "",
    };
  },
  methods: {
    async login() {
      const body = { name: this.name, pass: this.pass };
      const res = await axiosClient.post("/users/login", body);
      if (res?.data?.token) {
        sessionStorage.setItem("auth", res.data.token);
        sessionStorage.setItem("user", JSON.stringify(res.data.user));
        console.log(res.data.user);
        this.$router.push("/");
      } else {
        alert("sai tài khoản hoặc mật khẩu");
      }
    },
    register() {
      this.$router.push("/register");
    },
  },
};
</script>

<style scoped>
#app {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  width: 100vw;
}

.form {
  width: 20%;
  padding: 20px 20px;
  background-color: rgba(181, 255, 179, 0.4);
}
.form > .input {
  width: 100%;
}
.form > .btn-submit {
  display: flex;
  justify-content: center;
  margin-top: 10px;
}
.form > .btn-submit > .vs-button {
  width: 120px;
}
</style>
