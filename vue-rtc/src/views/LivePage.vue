<template>
  <div class="live-page">
    <v-row class="header">
      <v-col cols="2">
        <h1>LIVE STREAM</h1>
      </v-col>
      <v-col cols="7">
        <v-text-field
          label="Tìm kiếm"
          placeholder="Nhập tên livestream cần tìm"
          solo
        ></v-text-field>
      </v-col>
      <v-col cols="2" class="action">
        <v-btn depressed elevation="4" raised large>Tìm kiếm</v-btn>
        <v-btn depressed elevation="4" raised large>Tạo lịch</v-btn>
      </v-col>
    </v-row>
    <v-row class="content">
      <v-card
        v-for="(live, index) in lives"
        :key="index"
        elevation="2"
        outlined
        shaped
        tile
      >
        <v-card-title>{{ live.title }}</v-card-title>
        <v-card-subtitle
          >{{ live.startTime }} - {{ live.endTime }}</v-card-subtitle
        >
        <v-card-text>{{ live.description }}</v-card-text>
        <v-card-actions>
          <v-btn depressed elevation="4" raised large color="primary"
            >Tham gia ngay</v-btn
          >
          <v-btn depressed color="cyan" raised text>Đang diễn ra</v-btn>
        </v-card-actions>
      </v-card>
    </v-row>
    <v-row class="pagination">
      <div class="text-center">
        <v-pagination v-model="page" :length="6"></v-pagination>
      </div>
    </v-row>
  </div>
</template>
<script>
import { Manager } from "socket.io-client";
export default {
  data() {
    return {
      socket: null,
      page: 1,
      lives: [
        {
          _id: "122",
          peerId: "1",
          userId: "userIi",
          userName: "tho",
          title: "bàn hành",
          description: "quy tụ anh em bán ",
          startTime: "21-05-2023 17:30",
          endTime: "21-05-2023 21:00",
        },
        {
          _id: "122",
          peerId: "1",
          userId: "userIi",
          userName: "tho",
          title: "bàn hành",
          description:
            "quy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuo",
          startTime: "21-05-2023 17:30",
          endTime: "21-05-2023 21:00",
        },
        {
          _id: "122",
          peerId: "1",
          userId: "userIi",
          userName: "tho",
          title: "bàn hành",
          description:
            "quy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuo",
          startTime: "21-05-2023 17:30",
          endTime: "21-05-2023 21:00",
        },
        {
          _id: "122",
          peerId: "1",
          userId: "userIi",
          userName: "tho",
          title: "bàn hành",
          description:
            "quy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuo",
          startTime: "21-05-2023 17:30",
          endTime: "21-05-2023 21:00",
        },
        {
          _id: "122",
          peerId: "1",
          userId: "userIi",
          userName: "tho",
          title: "bàn hành",
          description:
            "quy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuo",
          startTime: "21-05-2023 17:30",
          endTime: "21-05-2023 21:00",
        },
        {
          _id: "122",
          peerId: "1",
          userId: "userIi",
          userName: "tho",
          title: "bàn hành",
          description:
            "quy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuo",
          startTime: "21-05-2023 17:30",
          endTime: "21-05-2023 21:00",
        },
        {
          _id: "122",
          peerId: "1",
          userId: "userIi",
          userName: "tho",
          title: "bàn hành",
          description:
            "quy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuo",
          startTime: "21-05-2023 17:30",
          endTime: "21-05-2023 21:00",
        },
      ],
    };
  },

  mounted() {
    const uri = process.env.DOMAIN_BE;
    const token = sessionStorage.getItem("auth");
    this.currentUser = JSON.parse(sessionStorage.getItem("user"));

    const manager = new Manager(uri, {
      extraHeaders: {
        authorization: `Beaer ${token}`,
      },
    });
    this.socket = manager.socket("/livestream", { forceNew: true });
    if (!token) return this.$router.push("login");
  },
  methods: {},
};
</script>
<style scoped>
.live-page {
  width: 100%;
  height: 100vh;
  padding: 20px 20px;
}
.live-page > .header {
  height: 70px;
}
.live-page > .header > .action {
  display: flex;
}
.live-page > .header > .action > .v-btn {
  margin-right: 25px;
}
.live-page > .content {
  display: flex;
  justify-content: flex-start;
  padding: 0 75px;
}
.live-page > .content > .v-card {
  width: 295px;
  height: 250px;
  margin: 10px 10px;
}
.live-page > .content > .v-card > .v-card__title {
  font-size: 24px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.live-page > .content > .v-card > .v-card__subtitle {
  color: red;
  padding-bottom: 0;
}
.live-page > .content > .v-card > .v-card__text {
  height: 115px;
  overflow-y: scroll;
}
.live-page > .pagination > .text-center {
  width: 100%;
}
</style>
