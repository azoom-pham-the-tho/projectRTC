<template>
  <div class="live-page">
    <v-row class="content">
      <v-col cols="20" class="left">
        <div class="video">
          <div class="eye">
            <v-tooltip bottom>
              <template v-slot:activator="{ on, attrs }">
                <div v-bind="attrs" v-on="on">
                  <span class="mdi mdi-eye-outline"></span>
                  <span> {{ userJoin.length }}</span>
                </div>
              </template>
              <div class="item" v-for="(item, index) in userJoin" :key="index">
                {{ item }}
              </div>
            </v-tooltip>
          </div>
          <video
            :srcObject.prop="myStream"
            class="video"
            autoplay
            volume="0"
            muted
          ></video>
        </div>
        <div class="action">
          <div class="mic">
            <span
              v-if="optionMedia.mic"
              class="material-symbols-outlined"
              @click="changeMic"
            >
              keyboard_voice
            </span>
            <span v-else class="material-symbols-outlined" @click="chaneMic">
              mic_off
            </span>
          </div>
          <div class="cam">
            <span
              v-if="optionMedia.cam"
              class="material-symbols-outlined"
              @click="changeCam"
            >
              videocam
            </span>
            <span v-else class="material-symbols-outlined" @click="changeCam">
              videocam_off
            </span>
          </div>
          <div class="share">
            <span
              v-if="optionMedia.share"
              class="material-symbols-outlined"
              @click="stopSharingScreen"
            >
              stop_screen_share
            </span>
            <span v-else class="material-symbols-outlined" @click="shareScreen">
              screen_share
            </span>
          </div>
          <div class="call">
            <span class="material-symbols-outlined" @click="onClose">
              call_end
            </span>
          </div>
        </div>
      </v-col>
      <v-col cols="4" class="right">
        <v-row class="title">
          <h1>{{ liveStream.title }}</h1>
          <p class="description">{{ liveStream.description }}</p>
          <p class="calendar">
            {{ liveStream.startTime }} ~ {{ liveStream.endTime }}
          </p>
        </v-row>
        <v-row class="comment">
          <h2>Comment</h2>
          <v-col cols="24">
            <div class="contentMessage">
              <div class="item" v-for="(item, index) in comments" :key="index">
                <div class="message">
                  <v-avatar :color="getRandomColorName()" size="25" title>
                    <v-tooltip left>
                      <template v-slot:activator="{ on, attrs }">
                        <span
                          v-bind="attrs"
                          v-on="on"
                          class="white--text text-span"
                          >{{ item.name.substring(0, 2) }}</span
                        >
                      </template>
                      <span>{{ item.name }}</span>
                    </v-tooltip>
                  </v-avatar>
                  &nbsp;
                  <p class="content">{{ item.content }}</p>
                  <p class="time">{{ item.time }}</p>
                </div>
              </div>
            </div>
          </v-col>
          <v-col cols="24">
            <v-text-field
              v-model="message"
              append-outer-icon="mdi-send"
              clear-icon="mdi-close-circle"
              clearable
              label="Nhập nội dung"
              :placeholder="'Gửi bình luận cho ' + liveStream.userName"
              solo
              @click:append-outer="sendMessage"
              @keydown.enter.prevent="sendMessage"
              hide-details="auto"
              type="text"
            ></v-text-field>
          </v-col>
        </v-row>
      </v-col>
    </v-row>
  </div>
</template>
<script>
import { Manager } from "socket.io-client";
import Peer from "skyway-js";
export default {
  data() {
    return {
      roomId: null,
      socket: null,
      liveStream: {
        _id: "122",
        peerId: "1",
        userId: "6450ca2c9002b1da349c288d",
        userName: "tho",
        title: "bán hành",
        description:
          "quy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuoquy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuo quy tụ anh em bán hành yasuo",
        startTime: "21-05-2023 17:30",
        endTime: "21-05-2023 21:00",
      },
      myStream: null,
      comments: [
        {
          userId: 1,
          name: "tho",
          content:
            "cdacd cdacdcda cdcdacd  cdcd cdacd  cdacds cdacdsc cxc xss cdd dacds lorem cda dacd s cda csd  fv cdad xdds xss  xs",
          time: "03:50",
        },
        {
          userId: 1,
          name: "tho1",
          content: "kkkk",
          time: "03:50",
        },
        {
          userId: 1,
          name: "tho",
          content:
            "cdacd cdacdcda cdcdacd  cdcd cdacd  cdacds cdacdsc cxc xss cdd dacds lorem cda dacd s cda csd  fv cdad xdds xss  xs",
          time: "03:50",
        },
        {
          userId: 1,
          name: "tho",
          content:
            "cdacd cdacdcda cdcdacd  cdcd cdacd  cdacds cdacdsc cxc xss cdd dacds lorem cda dacd s cda csd  fv cdad xdds xss  xs",
          time: "03:50",
        },
        {
          userId: 1,
          name: "tho",
          content:
            "cdacd cdacdcda cdcdacd  cdcd cdacd  cdacds cdacdsc cxc xss cdd dacds lorem cda dacd s cda csd  fv cdad xdds xss  xs",
          time: "03:50",
        },
        {
          userId: 1,
          name: "tho",
          content:
            "cdacd cdacdcda cdcdacd  cdcd cdacd  cdacds cdacdsc cxc xss cdd dacds lorem cda dacd s cda csd  fv cdad xdds xss  xs",
          time: "03:50",
        },
        {
          userId: 1,
          name: "tho",
          content:
            "cdacd cdacdcda cdcdacd  cdcd cdacd  cdacds cdacdsc cxc xss cdd dacds lorem cda dacd s cda csd  fv cdad xdds xss  xs",
          time: "03:50",
        },
        {
          userId: 1,
          name: "tho",
          content:
            "cdacd cdacdcda cdcdacd  cdcd cdacd  cdacds cdacdsc cxc xss cdd dacds lorem cda dacd s cda csd  fv cdad xdds xss  xs",
          time: "03:50",
        },
        {
          userId: 1,
          name: "tho",
          content:
            "cdacd cdacdcda cdcdacd  cdcd cdacd  cdacds cdacdsc cxc xss cdd dacds lorem cda dacd s cda csd  fv cdad xdds xss  xs",
          time: "03:50",
        },
        {
          userId: 1,
          name: "tho",
          content:
            "cdacd cdacdcda cdcdacd  cdcd cdacd  cdacds cdacdsc cxc xss cdd dacds lorem cda dacd s cda csd  fv cdad xdds xss  xs",
          time: "03:50",
        },
        {
          userId: 1,
          name: "tho",
          content:
            "cdacd cdacdcda cdcdacd  cdcd cdacd  cdacds cdacdsc cxc xss cdd dacds lorem cda dacd s cda csd  fv cdad xdds xss  xs",
          time: "03:50",
        },
        {
          userId: 1,
          name: "tho",
          content:
            "cdacd cdacdcda cdcdacd  cdcd cdacd  cdacds cdacdsc cxc xss cdd dacds lorem cda dacd s cda csd  fv cdad xdds xss  xs",
          time: "03:50",
        },
        {
          userId: 1,
          name: "tho",
          content:
            "cdacd cdacdcda cdcdacd  cdcd cdacd  cdacds cdacdsc cxc xss cdd dacds lorem cda dacd s cda csd  fv cdad xdds xss  xs",
          time: "03:50",
        },
        {
          userId: 1,
          name: "tho",
          content:
            "cdacd cdacdcda cdcdacd  cdcd cdacd  cdacds cdacdsc cxc xss cdd dacds lorem cda dacd s cda csd  fv cdad xdds xss  xs",
          time: "03:50",
        },
        {
          userId: 1,
          name: "tho",
          content:
            "cdacd cdacdcda cdcdacd  cdcd cdacd  cdacds cdacdsc cxc xss cdd dacds lorem cda dacd s cda csd  fv cdad xdds xss  xs",
          time: "03:50",
        },
        {
          userId: 1,
          name: "tho",
          content:
            "cdacd cdacdcda cdcdacd  cdcd cdacd  cdacds cdacdsc cxc xss cdd dacds lorem cda dacd s cda csd  fv cdad xdds xss  xs",
          time: "03:50",
        },
        {
          userId: 1,
          name: "tho",
          content:
            "cdacd cdacdcda cdcdacd  cdcd cdacd  cdacds cdacdsc cxc xss cdd dacds lorem cda dacd s cda csd  fv cdad xdds xss  xs",
          time: "03:50",
        },
        {
          userId: 1,
          name: "tho",
          content:
            "cdacd cdacdcda cdcdacd  cdcd cdacd  cdacds cdacdsc cxc xss cdd dacds lorem cda dacd s cda csd  fv cdad xdds xss  xs",
          time: "03:50",
        },
      ],
      userJoin: [],
      message: "",
      peers: [],
      optionMedia: {
        cam: true, //{ width: 720, height: 480 },
        mic: false,
        share: false,
      },
    };
  },

  mounted() {
    this.roomId = this.$route.params.id;
    const uri = "http://94.237.79.161:8001/";
    const token = sessionStorage.getItem("auth");
    this.currentUser = JSON.parse(sessionStorage.getItem("user"));

    const manager = new Manager(uri, {
      extraHeaders: {
        authorization: `Beaer ${token}`,
      },
    });
    this.socket = manager.socket("/livestream", { forceNew: true });
    if (!token) return this.$router.push("login");

    //local: c6cd73b9-f4df-4111-8844-e78ecaa57a7f
    //server: 7a81ff45-fde5-4beb-be41-85e92e0d0037
    this.peer = new Peer(this.name, {
      key: "c6cd73b9-f4df-4111-8844-e78ecaa57a7f",
      debug: 3,
    });
    this.peer.on("open", (peerId) => {
      this.peerId = peerId;
      if (this.currentUser.id == this.liveStream.userId) {
        console.log("getUserMedia");
        navigator.mediaDevices
          .getUserMedia({
            video: this.optionMedia.cam,
            audio: this.optionMedia.mic,
          })
          .then((stream) => {
            this.myStream = stream;
          })
          .then(this.joinRoom)
          .catch((err) => {
            console.log(err);
            // alert(`Error: Your device cannot use this type of stream.`);
          });
      } else {
        this.joinRoom();
      }
    });
  },
  methods: {
    joinRoom() {
      const peer = this.peer;

      if (this.myStream) {
        this.room = peer.joinRoom(this.roomId, {
          mode: "sfu",
          stream: this.myStream,
        });
      } else {
        this.room = peer.joinRoom(this.roomId, {
          mode: "sfu",
        });
      }

      this.room.once("open", () => {
        console.log("=== You joined ===\n");
      });
      this.room.on("peerJoin", (peerId) => {
        console.log(`=== ${peerId} joined ===\n`);
      });

      this.room.on("peerLeave", (peerId) => {
        console.log("peerLeave", peerId);
      });

      this.room.on("stream", async (stream) => {
        console.log("stream", stream);
        // this.peers = this.peers.filter((p) => p.peerId !== stream.peerId);
        // this.peers.push({ peerId: stream.peerId, stream: stream });
        // console.log("peers", this.peers.length);
        this.userJoin.push(this.currentUser.name);
        this.myStream = stream;
      });
      this.room.on("data", ({ data }) => {
        // Xử lý dữ liệu nhận được từ kênh dữ liệu
        console.log("data", data);
      });
    },
    getRandomColorName() {
      const colorNames = [
        "red",
        "blue",
        "green",
        "yellow",
        "orange",
        "purple",
        "pink",
        "brown",
        "teal",
        "lime",
        "maroon",
      ];
      const randomIndex = Math.floor(Math.random() * colorNames.length);
      return colorNames[randomIndex];
    },
    sendMessage() {
      console.log("send");
      this.room.send("MESSAGE", "thoddya");
    },
  },
};
</script>
<style scoped>
.live-page {
  width: 100%;
  height: 100vh;
  padding: 30px 50px;
}
.live-page > .content > .left {
  height: 90vh;
}
.live-page > .content > .left > .video {
  width: 60vw;
  height: 85vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  background-color: black;
  position: absolute;
}
.live-page > .content > .left > .video > video {
  width: auto;
  height: auto;
}
.live-page > .content > .left > .video > .eye {
  color: white;
  position: absolute;
  top: 10px;
  right: 30px;
  z-index: 1;
}
.live-page > .content > .left > .video > .eye .material-symbols-outlined {
  padding: 0;
}
.live-page > .content > .left > .action {
  position: absolute;
  bottom: 30px;
  width: 60vw;
  height: 8vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: rgba(225, 225, 225, 1);
}

.live-page > .content > .right {
  height: 97vh;
  margin-left: 20px;
}
.live-page > .content > .right > .title > h1 {
  font-size: 28px;
}
.live-page > .content > .right > .title > .calendar {
  font-size: 16px;
  margin: 0;
}
.right > .title > .description {
  height: 100px;
  overflow-y: scroll;
  font-size: 18px;
  margin: 0;
}
.comment {
  display: flex;
  flex-direction: column;
  background-color: aliceblue;
}
.comment .contentMessage {
  display: flex;
  overflow-y: auto;
  flex-direction: column;
  width: 100%;
  height: 58vh;
  padding: 10px;
}
.comment .contentMessage > .item > .message {
  display: flex;
  margin: 1px 0;
  font-size: 14px;
  color: rgb(49, 49, 49);
  width: 100%;
}

.comment .contentMessage > .item > .message > .content {
  background-color: rgb(187, 187, 187);
  padding: 2px 10px;
  border-radius: 5px;
}
.comment .contentMessage > .item > .message > .time {
  color: rgb(160, 160, 160);
  padding: 2px 10px;
}

.mic,
.cam,
.share,
.call {
  margin: 0 20px;
  border-radius: 15px;
  cursor: pointer;
}
.mic,
.share,
.cam {
  background-color: rgb(187, 187, 187);
}
.call {
  color: white;
  background: rgb(255, 31, 31);
}
.material-symbols-outlined {
  padding: 15px;
  font-size: 25px;
  -webkit-touch-callout: none;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  -o-user-select: none;
  user-select: none;
}
</style>
