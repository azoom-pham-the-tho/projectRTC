<template>
  <v-app>
    <router-view />
  </v-app>
</template>

<script>
export default {
  name: "App",

  data: () => ({
    //
  }),
};
</script>

<style>
.v-dialog {
  background-color: white;
  padding: 20px;
}
.v-dialog > h4 {
  text-align: center;
  font-size: 24px;
  margin: 10px 0;
}
.v-dialog > h4 > .name {
  font-size: 30px;
  color: coral;
}
.v-dialog > .action {
  display: flex;
  justify-content: space-evenly;
}
.v-dialog > .action > .btn {
  width: 120px;
  color: white;
}
</style>
