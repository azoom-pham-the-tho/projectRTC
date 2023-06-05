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
            <span v-else class="material-symbols-outlined" @click="changeMic">
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
                  <v-avatar color="green" size="25" title>
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
                  <p class="content">
                    <span v-if="item.type == 'text'">
                      {{ item.content }}
                    </span>
                    <span v-if="item.type == 'file'">
                      {{ handelSrcViewImage(item.content, index) }}
                      <v-img
                        contain
                        :lazy-src="item.imgSrc"
                        max-height="250"
                        max-width="320"
                        :src="item.imgSrc"
                      ></v-img>
                    </span>
                  </p>
                  <p class="time">{{ item.time }}</p>
                </div>
              </div>
            </div>
          </v-col>
          <v-col class="input" cols="24">
            <v-file-input
              class="file"
              v-model="file"
              label="File selected"
              outlined
              dense
              show-size
              hide-details="auto"
              :hide-input="file ? false : true"
              :append-outer-icon="file ? 'mdi-send' : ''"
              clear-icon="mdi-close-circle"
              @click:append-outer="sendMessage"
              @keyup.enter.prevent="sendMessage"
            ></v-file-input>
            <v-text-field
              v-if="!file"
              class="text"
              v-model="message"
              append-outer-icon="mdi-send"
              clear-icon="mdi-close-circle"
              clearable
              label="Nhập nội dung"
              :placeholder="'Gửi bình luận cho ' + liveStream.userName"
              solo
              @click:append-outer="sendMessage"
              @keyup.enter.prevent="sendMessage"
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
// import { Manager } from "socket.io-client";
import Peer from "skyway-js";
import moment from "moment";
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
        startTime: "Fri Jun 02 2023 11:30:00 GMT+0700",
        endTime: "Fri Jun 02 2023 13:00:00 GMT+0700",
      },
      myStream: null,
      comments: [],
      userJoin: [],
      message: "",
      file: null,
      imgTemp: "",
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
    // const uri = "https://api.thopt.website";
    // const token = sessionStorage.getItem("auth");
    this.currentUser = JSON.parse(sessionStorage.getItem("user"));

    // const manager = new Manager(uri, {
    //   extraHeaders: {
    //     authorization: `Beaer ${token}`,
    //   },
    // });
    // this.socket = manager.socket("/livestream", { forceNew: true });
    // if (!token) return this.$router.push("login");

    console.log("2155a457-35f2-407a-a5bb-074ce7b29242");
    this.peer = new Peer(this.name, {
      key: "2155a457-35f2-407a-a5bb-074ce7b29242",
      debug: 3,
    });
    this.peer.on("open", (peerId) => {
      this.peerId = peerId;
      // navigator.mediaDevices
      //   .getUserMedia({
      //     video: this.optionMedia.cam,
      //     audio: this.optionMedia.mic,
      //   })
      //   .then((stream) => {
      //     this.myStream = stream;
      //   })
      //   .then(this.joinRoom)
      //   .catch((err) => {
      //     console.log(err);
      //     alert(`Error: Your device cannot use this type of stream.`);
      //   });
      // if (this.currentUser.id == this.liveStream.userId) {
      //   console.log("getUserMedia");
      //   navigator.mediaDevices
      //     .getUserMedia({
      //       video: this.optionMedia.cam,
      //       audio: this.optionMedia.mic,
      //     })
      //     .then((stream) => {
      //       this.myStream = stream;
      //     })
      //     .then(this.joinRoom)
      //     .catch((err) => {
      //       console.log(err);
      //       // alert(`Error: Your device cannot use this type of stream.`);
      //     });
      // } else {
      //   this.joinRoom();
      // }
      this.joinRoom();
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
        this.peers.push(peer);
      });

      this.room.on("peerLeave", (peerId) => {
        console.log("peerLeave", peerId);
        this.peers = this.peers.filter((item) => item != peer);
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
        this.comments = [this.comment, ...data];
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
      if (this.message || this.file?.name) {
        const duration = moment.duration(
          moment().diff(moment(this.liveStream.startTime))
        );
        const content = this.message || this.file;
        let type = "";
        if (this.message) {
          type = "text";
        }
        if (this.file) {
          type = "file";
        }
        const data = {
          type,
          content,
          channel: "message",
          userId: 1,
          name: "tho",
          time: `${duration.hours()}:${duration.minutes()}:${duration.seconds()}`,
        };

        Vue.set(this.comments, this.comments.length+1, data)
        this.message = null;
        this.file = null;
        this.room.send(data);
      }
    },
    handelSrcViewImage(file, index) {
      if (file && file.type?.startsWith("image/")) {
        const reader = new FileReader();
        // Đọc tệp ảnh
        reader.onload = () => {
          this.comments[index].imgSrc = reader.result;
        };

        // Đọc dữ liệu tệp ảnh dưới dạng URL dữ liệu
        reader.readAsDataURL(file);
      }
    },
    changeMic() {
      this.optionMedia.mic = !this.optionMedia.mic;
      this.myStream.getAudioTracks()[0].enabled = this.optionMedia.mic;
      return true;
    },
    changeCam() {
      this.optionMedia.cam = !this.optionMedia.cam;
      this.myStream.getVideoTracks()[0].enabled = this.optionMedia.cam;
      this.room.replaceStream(this.myStream);
      return true;
    },
    shareScreen() {
      navigator.mediaDevices
        .getDisplayMedia({
          video: {
            cursor: "always",
            frameRate: 30,
          },
        })
        .then((streamScreen) => {
          this.optionMedia.share = !this.optionMedia.share;
          this.streamTemp = this.myStream;
          this.myStream = streamScreen;
          this.room.replaceStream(streamScreen);
          streamScreen.getVideoTracks()[0].onended = () => {
            //listen when click stop share on browser
            this.stopSharingScreen();
          };
        });
      return true;
    },
    stopSharingScreen() {
      console.log("end share");
      this.room.replaceStream(this.streamTemp);
      this.myStream = this.streamTemp;
    },
    onClose() {
      this.socket.emit("end-call", this.roomId);
      if (this.room) this.room.close();
      if (this.peer) this.peer.destroy();
      this.myStream.getTracks().forEach((track) => track.stop());
      this.$router.push("/");
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
.comment > .input {
  display: flex;
  background-color: rgba(225, 225, 225, 1);
}
.comment > .input > .text {
  width: 100%;
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
