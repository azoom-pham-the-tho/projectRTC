export default {
  setLocalStream(stream, mirrorMode = true) {
    const localVidElem = document.getElementById("local");

    localVidElem.srcObject = stream;
    mirrorMode
      ? localVidElem.classList.add("mirror-mode")
      : localVidElem.classList.remove("mirror-mode");
  },
  userMediaAvailable() {
    return !!(
      navigator.getUserMedia ||
      navigator.webkitGetUserMedia ||
      navigator.mozGetUserMedia ||
      navigator.msGetUserMedia
    );
  },
  getUserFullMedia() {
    if (this.userMediaAvailable()) {
      return navigator.mediaDevices.getUserMedia({
        video: { width: 720, height: 480 },
        // audio: {
        //   echoCancellation: true,
        //   noiseSuppression: true,
        // },
      });
    } else {
      throw new Error("User media not available");
    }
  },
  getIceServer() {
    return {
      iceServers: [
        {
          urls: ["stun:eu-turn4.xirsys.com"],
        },
        {
          username:
            "ml0jh0qMKZKd9P_9C0UIBY2G0nSQMCFBUXGlk6IXDJf8G2uiCymg9WwbEJTMwVeiAAAAAF2__hNSaW5vbGVl",
          credential: "4dd454a6-feee-11e9-b185-6adcafebbb45",
          urls: [
            "turn:eu-turn4.xirsys.com:80?transport=udp",
            "turn:eu-turn4.xirsys.com:3478?transport=tcp",
          ],
        },
      ],
    };
  },
};
