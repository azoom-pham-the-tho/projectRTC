export default {
  getKeyWithDomain() {
    if(window.location.hostname =='thopt.website'){
      return "2155a457-35f2-407a-a5bb-074ce7b29242"
    }
    if(window.location.hostname =='chromewebdata'){
      return "7a81ff45-fde5-4beb-be41-85e92e0d0037"
    }
    if(window.location.hostname =='localhost'){
      return "c6cd73b9-f4df-4111-8844-e78ecaa57a7f"
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
  userMediaAvailable() {
    return !!(
      navigator.getUserMedia ||
      navigator.webkitGetUserMedia ||
      navigator.mozGetUserMedia ||
      navigator.msGetUserMedia
    );
  },
  getUserFullMedia(option) {
    if (this.userMediaAvailable()) {
      return navigator.mediaDevices.getUserMedia({
        video: option.cam,
        audio: option.mic,
      });
    } else {
      throw new Error("User media not available");
    }
  },
  getScreenMedia() {
    if (this.userMediaAvailable()) {
      return navigator.mediaDevices.getDisplayMedia({
        video: {
          cursor: "always",
        },
        audio: {
          echoCancellation: true,
          noiseSuppression: true,
          sampleRate: 44100,
        },
      });
    } else {
      throw new Error("User media not available");
    }
  },
};
