<template>
  <div class="layout">
    <div class="content-page">
      <div class="main">
        <div class="list-connect">
          <div
            class="item"
            v-for="item in peers"
            :key="item"
            @click="clickVideoInConnection(item)"
          >
            <img
              class="item"
              width="240"
              height="180"
              src="https://quantrithcs.vinhphuc.edu.vn/UploadImages/thcstthoason/anh-phong-canh-dep-nhat-the-gioi.jpg"
              alt=""
            />
            <p class="name">{{ item.name }}</p>
          </div>
        </div>
        <div class="video">
          <h1 class="group-name">Nhóm của tôi</h1>
          <div class="screen">
            <!-- <video
              class="local-video"
              id="local"
              volume="0"
              autoplay
              muted
              v-if="myStream"
              :srcObject.prop="myStream"
            ></video> -->
            <img
              width="1080"
              height="720"
              src="https://quantrithcs.vinhphuc.edu.vn/UploadImages/thcstthoason/anh-phong-canh-dep-nhat-the-gioi.jpg"
              alt=""
            />
          </div>
          <div class="toggle-chat" @click="toggleChat">
            <span v-if="status.showChat" class="material-symbols-outlined">
              close
            </span>
            <v-badge v-if="!status.showChat" color="red" content="99">
              <span class="material-symbols-outlined"> comment </span></v-badge
            >
          </div>

          <div class="screen-name">Screen of {{ screenName }}</div>
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
              <span
                v-else
                class="material-symbols-outlined"
                @click="shareScreen"
              >
                screen_share
              </span>
            </div>
            <div class="call">
              <span class="material-symbols-outlined" @click="onClose">
                call_end
              </span>
            </div>
          </div>
        </div>
      </div>
      <div class="chat" v-if="status.showChat">
        <h2>Member joined: {{ members.length }}</h2>
        <div class="members">
          <div class="item" v-for="(item, index) in members" :key="index">
            {{ item.name }}
          </div>
        </div>
        <h2>Comment</h2>
        <div class="contentMessage">
          <div class="item" v-for="(item, index) in messageChat" :key="index">
            <div>
              <p class="user">{{ item.name }} &nbsp;</p>
              <p class="content">{{ item?.message }}</p>
              <p class="content">{{ item?.time }}</p>
            </div>
          </div>
        </div>
        <div class="inputChat">
          <v-text-field
            v-model="message"
            label="Solo"
            placeholder="Placeholder"
            append-outer-icon="mdi-send"
            solo
            clear-icon="mdi-close-circle"
            clearable
            @click:append-outer="sendMessage"
            @keydown.enter.prevent="sendMessage"
            hide-details="auto"
            type="text"
          ></v-text-field>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import io from "socket.io-client";
import Peer from "skyway-js";
export default {
  name: "GroupCall",
  data() {
    return {
      peer: {},
      peerId: "",
      roomId: "", // room id
      room: "", // room of skyway
      socket: "",
      myStream: "",
      otherStream: "",
      streamTemp: {}, // temp when share screen
      peers: [
        { name: "tho1", peerId: 1 },
        { name: "tho2", peerId: 2 },
        { name: "tho3", peerId: 3 },
        { name: "tho4", peerId: 4 },
        { name: "tho5", peerId: 5 },
        { name: "tho6", peerId: 6 },
        { name: "tho7", peerId: 7 },
        { name: "tho8", peerId: 8 },
        { name: "tho9", peerId: 9 },
      ], // list peer connect
      screenShare: {},
      screenName: "tho",
      messageChat: [{ name: "tho1", message: "cdcasdca", time: "04:23" }],
      members: [
        {
          name: "tho",
        },
        {
          name: "tho 1",
        },
        {
          name: "tho 2",
        },
        {
          name: "tho 2",
        },
        {
          name: "tho 2",
        },
        {
          name: "tho 2",
        },
        {
          name: "tho 2",
        },
      ],
      optionMedia: {
        cam: true, //{ width: 720, height: 480 },
        mic: false,
        share: false,
      },
      status: {
        showChat: false,
      },
    };
  },
  mounted() {
    this.roomId = this.$route.params.id;
    const uri = process.env.DOMAIN_BE;
    const token = sessionStorage.getItem("auth");
    if (!token) return this.$router.push("login");
    this.socket = io(uri, {
      extraHeaders: {
        authorization: `Beaer ${token}`,
      },
    });
    this.peer = new Peer(this.name, {
      key: "2155a457-35f2-407a-a5bb-074ce7b29242",
      debug: 3,
    });
    this.peer.on("open", (peerId) => {
      this.peerId = peerId;
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
    });

    this.socket.on("end-call", () => {
      this.myStream.getTracks().forEach((track) => track.stop());
      this.$router.push("/");
    });
  },
  methods: {
    toggleChat() {
      this.status.showChat = !this.status.showChat;
      console.log(this.status.showChat);
      return true;
    },
    clickVideoInConnection(peer) {
      this.screenName = peer.name;
      console.log(peer);
    },
    joinRoom() {
      const peer = this.peer;
      if (this.room) {
        this.room.replaceStream(this.localStream);
        return;
      }
      this.room = peer.joinRoom(this.roomId, {
        mode: "mesh",
        stream: this.myStream,
      });

      this.room.once("open", () => {
        console.log("=== You joined ===\n");
      });
      this.room.on("peerJoin", (peerId) => {
        console.log(`=== ${peerId} joined ===\n`);
      });

      this.room.on("peerLeave", (peerId) => {
        this.peers = this.peers.filter((p) => p.peerId !== peerId);
      });

      this.room.on("stream", async (stream) => {
        console.log("stream", stream);
        this.peers = this.peers.filter((p) => p.peerId !== stream.peerId);
        this.peers.push({ peerId: stream.peerId, stream: stream });
        this.otherStream = stream;
      });
    },
    destroyed() {
      if (this.room) this.room.close();
      if (this.peer) this.peer.destroy();
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
.layout {
  position: fixed;
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  left: 0;
  top: 0;
}

.layout > .content-page {
  display: flex;
  width: 100%;
  height: 100%;
  padding: 10px;
}
.main {
  width: 100%;
  background: rgb(0, 0, 0);
  color: white;
  display: flex;
}
.chat {
  flex: 0 0 20%;
  width: 20%;
  background: rgb(209, 209, 209);
  padding: 10px;
  border-left: 2px solid rgb(155, 155, 155);
}
.main > .list-connect {
  width: 20%;
  display: flex;
  align-items: center;
  flex-direction: column;
  overflow-y: auto;
  border-right: 2px solid rgb(155, 155, 155);
}
.main > .list-connect > .item {
  position: relative;
  padding: 2px 0;
  cursor: pointer;
}
.main > .list-connect > .item > .name {
  position: absolute;
  bottom: 10px;
  left: 0;
  color: black;
  background-color: rgba(252, 252, 252, 0.363);
  padding: 2px 10px;
  margin: 0;
}
.main > .video {
  width: 80%;
  display: flex;
  flex-direction: column;

  position: relative;
}
.main > .video > .group-name {
  font-size: 32px;
  padding: 0 40px;
}
.main > .video > .screen-name {
  position: absolute;
  bottom: 60px;
  left: 20px;
  font-size: 24px;
}
.main > .video > .toggle-chat {
  position: absolute;
  top: 30px;
  right: 40px;
  cursor: pointer;
}

.main > .video > .action {
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: rgba(143, 143, 143, 0.1);
}
.main > .video > .screen {
  height: 89%;
  display: flex;
  justify-content: center;
  align-items: center;
}
.chat > .contentMessage {
  height: 70%;
  background: white;
}
.chat > .members {
  height: 15vh;
  overflow-y: auto;
  padding: 5px;
  background: white;
}
.chat > .members > .item {
  width: 100%;
}
.chat > .inputChat {
  background: white;
  padding: 10px 5px;
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
  background-color: rgb(220, 220, 220);
}
.call {
  color: white;
  background: rgb(255, 31, 31);
}
.action .material-symbols-outlined {
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
