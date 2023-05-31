<template>
  <div class="layout">
    <div class="otherVideo">
      <video
        class="other-video"
        id="local"
        volume="0"
        autoplay
        muted
        :srcObject.prop="otherStream"
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
    <div class="myVideo">
      <video
        class="local-video"
        id="local"
        volume="0"
        autoplay
        muted
        v-if="myStream"
        :srcObject.prop="myStream"
      ></video>
    </div>
  </div>
</template>
<script>
import io from "socket.io-client";
import Peer from "skyway-js";
export default {
  name: "VideoLocal",
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
      peers: [], // list peer connect
      screenShare: {},
      optionMedia: {
        cam: true, //{ width: 720, height: 480 },
        mic: false,
        share: false,
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
      key: "c6cd73b9-f4df-4111-8844-e78ecaa57a7f",
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
  width: 100%;
  height: 100%;
  left: 0;
  top: 0;
  background-color: black;
}
.otherVideo {
  width: 100%;
  height: 100%;
}
.other-video {
  width: 100%;
  height: 100%;
}

.myVideo {
  z-index: 1;
  position: absolute;
  bottom: 8vh;
  right: 10px;
  width: 176px;
  height: auto;
  max-height: 250px;
}
.myVideo:hover {
  width: 320px;
  transition: all ease-in-out 0.15s;
}
.local-video {
  width: 100%;
  height: 100%;
  border-radius: 10px;
  background-color: bisque;
  box-shadow: rgba(0, 0, 0, 0.25) 0px 14px 28px,
    rgba(0, 0, 0, 0.22) 0px 10px 10px;
}
.action {
  position: absolute;
  bottom: 0;
  height: 8vh;
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: rgba(225, 225, 225, 0.1);
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
