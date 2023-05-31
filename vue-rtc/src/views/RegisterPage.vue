<template>
  <div id="app">
    <form class="form" @submit.prevent="loginWithPassword">
      <h1>REGISTER</h1>
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
        <v-btn outlined @click="register" small> Register </v-btn>
      </div>
      <div class="btn-register" @click="login">login</div>
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
      alert: "",
    };
  },
  methods: {
    async register() {
      const body = { name: this.name, pass: this.pass };
      await axiosClient.post("/users/create", body);
      this.$router.push("/login");
    },
    login() {
      this.$router.push("/login");
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
  display: flex;
  justify-content: center;
  flex-direction: column;
}
.form > .input {
  width: 100%;
}
.form > .btn-submit {
  display: flex;
  justify-content: center;
  margin-top: 15px;
}
.form > .btn-submit > .vs-button {
  width: 120px;
}
</style>
