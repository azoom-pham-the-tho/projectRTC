<template>
  <div class="chat-page">
    <div class="content">
      <div class="sidebar">
        <div class="user">
          <div
            :class="['item', getClassNameWithStatus(item.status)]"
            v-for="(item, index) in listUser"
            :key="index"
            @click="clickToUser(item._id, item.name)"
          >
            {{ item.name }}
            <span v-if="item._id == currentUser.id">(me)</span>
          </div>
        </div>
        <div class="chat">
          <div
            :class="[
              'item',
              item.read?.includes(currentUser.id) && 'notiGroup',
            ]"
            v-for="(item, index) in groupChat"
            :key="index"
            @click="
              getMessageInGroup(item._id, item.name, item.type, item.members)
            "
            @dblclick="deleteGroup(item._id, item.name)"
          >
            <p class="groupName">
              {{ item?.name }}
            </p>
            <div class="subMessage">
              <span>
                {{ item.messages[0]?.name }}
              </span>
              : &nbsp;
              <span class="message">
                {{ item.messages[0]?.content }}
              </span>
            </div>
          </div>
        </div>
      </div>
      <div class="message">
        <div class="header" v-if="groupCurrent">
          <p class="groupName">
            {{ groupCurrent.groupName }}
            <span class="usersGroup" v-if="groupCurrent.type == 2">
              <v-tooltip bottom>
                <template v-slot:activator="{ on, attrs }">
                  <span v-bind="attrs" v-on="on"
                    >{{ groupCurrent.members.length }} users</span
                  >
                </template>
                <div
                  class="item"
                  v-for="(item, index) in groupCurrent.members"
                  :key="index"
                  @click="call(item._id, item.status, item.name)"
                >
                  {{ item.name }}
                  <span v-if="item._id == currentUser.id">(me)</span>
                </div>
              </v-tooltip>
            </span>
          </p>

          <div class="action">
            <span
              class="material-symbols-outlined"
              @click="() => (dialogGroup = true)"
              v-if="groupCurrent.type == 2"
            >
              group_add
            </span>
            <span class="material-symbols-outlined" @click="call">
              videocam
            </span>
          </div>
        </div>
        <div class="contentMessage">
          <div class="item" v-for="(item, index) in messageChat" :key="index">
            <div :class="item.userId == currentUser.id ? 'right' : 'left'">
              <p class="user" v-if="item.userId != currentUser.id">
                {{ item.name }} &nbsp;
              </p>
              <p class="content">{{ item?.content }}</p>
            </div>
          </div>
        </div>
        <div class="inputChat" v-if="groupCurrent">
          <v-text-field
            v-model="message"
            append-outer-icon="mdi-send"
            filled
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

    <v-dialog class="dialog call" v-model="dialogCall" width="500">
      <h4>
        <b class="name"> {{ contentDialog }}</b>
      </h4>
      <div class="action">
        <v-btn
          v-if="userCall.id"
          class="btn"
          color="primary"
          @click="acceptJoin"
        >
          <span class="material-symbols-outlined"> phone_in_talk </span>
        </v-btn>
        <v-btn class="btn" color="pink" @click="rejectJoin">
          <span class="material-symbols-outlined"> phone_disabled </span>
        </v-btn>
      </div>
    </v-dialog>
    <v-dialog class="dialog add-user-group" v-model="dialogGroup" width="500">
      <h4>
        <b class="name">Add user to {{ groupCurrent.groupName }}</b>
      </h4>
      <v-container fluid>
        <v-row align="center">
          <v-col>
            <v-select
              v-model="userAddGroup"
              :items="userSelectInGroup"
              item-text="name"
              item-value="_id"
              chips
              label="Chips"
              multiple
              solo
              full-width
            ></v-select>
          </v-col>
        </v-row>
      </v-container>
      <div class="action">
        <v-btn class="btn" color="primary" @click="submitAddUser">
          <span class="material-symbols-outlined"> done </span>
        </v-btn>
      </div>
    </v-dialog>
  </div>
</template>
<script>
import { Manager } from "socket.io-client";
export default {
  data() {
    return {
      dialogCall: false,
      dialogGroup: false,
      contentDialog: "",
      userCall: {
        // nhận khi có người gọi đến
        id: "",
        name: "",
        roomId: "",
      },
      listUser: [],
      socketCall: null,
      socketChat: null,
      currentUser: {},
      groupChat: [],
      userSelectInGroup: [],
      userAddGroup: [],
      groupCurrent: "",
      chatName: "",
      messageChat: [],
      message: "",
    };
  },

  mounted() {
    const uri = "http://94.237.79.161:8001";
    const token = sessionStorage.getItem("auth");
    this.currentUser = JSON.parse(sessionStorage.getItem("user"));

    const manager = new Manager(uri, {
      extraHeaders: {
        authorization: `Beaer ${token}`,
      },
    });
    this.socketCall = manager.socket("/call", { forceNew: true });
    this.socketChat = manager.socket("/chat", { forceNew: true });
    if (!token) return this.$router.push("login");
    this.handleSocketCall();
    this.handleSocketChat();
  },
  methods: {
    handleSocketCall() {
      this.socketCall.on("connect", () => {
        this.socketCall.emit("get-all-user");
        this.socketCall.on("disconnect", () => {
          console.log("user disconnected");
        });
      });
      this.socketCall.on("get-all-user", (listUser) => {
        this.listUser = listUser;
      });
      this.socketCall.on("user-call", (userCall, roomId) => {
        console.log(userCall);
        this.userCall.name = userCall?.name;
        this.userCall.id = userCall.id;
        this.userCall.roomId = roomId;
        this.contentDialog = this.userCall?.name + " đang gọi cho bạn";
        this.dialogCall = true;
      });
      this.socketCall.on("accept-join", (roomId) => {
        console.log("accept-join");
        this.$router.push(`/call/${roomId}`);
      });
      this.socketCall.on("reject-join", () => {
        this.dialogCall = false;
      });
    },
    handleSocketChat() {
      this.socketCall.on("connect", () => {
        this.socketChat.emit("group-chat");
      });
      this.socketChat.on("group-chat", (groupChat) => {
        this.groupChat = groupChat;
      });
      this.socketChat.on("message-in-group", (messageChat) => {
        this.messageChat = messageChat ? messageChat.messages.reverse() : [];
        var container = this.$el.querySelector(".contentMessage");
        container.scrollBottom = container.scrollHeight;
      });
      this.socketChat.on("chat", () => {
        this.socketChat.emit("message-in-group", {
          groupId: this.groupCurrent.groupId,
        });
        this.socketChat.emit("group-chat");
      });
      this.socketChat.on("group-chat-user-to-user", (groupId) => {
        if (groupId) {
          this.groupCurrent.groupId = groupId;
          this.socketChat.emit("message-in-group", { groupId });
        }
      });
      this.socketChat.on("delete-group", () => {
        this.socketChat.emit("group-chat");
      });
    },
    call() {
      const { groupId } = this.groupCurrent;
      console.log(this.groupCurrent);
      const user = this.listUser.find((item) => item._id == groupId);

      if (user?.status == 2) {
        this.dialogCall = true;
        this.contentDialog = "bạn  đang gọi cho " + user.name;
        this.socketCall.emit("user-call", user._id);
      } else {
        alert("user offline");
      }
    },
    acceptJoin() {
      this.$router.push(`/call/${this.userCall.roomId}`);
      this.socketCall.emit("accept-join", {
        userHost: this.userCall.id,
        roomId: this.userCall.roomId,
      });
    },
    rejectJoin() {
      this.dialogCall = false;
      this.socketCall.emit("reject-join", this.groupCurrent.groupId);
    },
    getClassNameWithStatus(status) {
      switch (status) {
        case 1:
          return "-offline";
        case 2:
          return "-online";
        case 3:
          return "-call";
        default:
          return "";
      }
    },
    getMessageInGroup(groupId, groupName, type, members = []) {
      this.groupCurrent = { groupId, groupName, members, type };
      this.socketChat.emit("message-in-group", { groupId });
      const listUser = [...this.listUser];
      this.userSelectInGroup = listUser?.filter(
        (item) => !members?.find((member) => member._id == item._id)
      );
    },
    clickToUser(id, name) {
      if (this.currentUser.id != id) {
        console.log(id);
        this.groupCurrent = { groupId: id, groupName: name, type: 1 };
        this.messageChat = [];
        this.socketChat.emit("group-chat-user-to-user", id);
      }
    },
    sendMessage() {
      if (!this.groupCurrent) {
        alert("hãy vào một nhóm để chat");
        return;
      }
      if (!this.message) {
        alert("hãy nhập nội dung để chat");
        return;
      }
      this.socketChat.emit("chat", {
        groupId: this.groupCurrent.groupId,
        message: this.message,
        type: this.groupCurrent.type,
      });
      this.message = "";
    },
    submitAddUser() {
      console.log(this.groupCurrent.members);
      console.log(this.userSelectInGroup);
    },
    deleteGroup(groupId, groupName) {
      if (confirm("Bạn muốn xoá " + groupName + " ?")) {
        this.socketChat.emit("delete-group", groupId);
      }
    },
  },
};
</script>
<style scoped>
.chat-page > .content {
  display: flex;
  width: 100%;
  height: 100vh;
  padding: 50px 50px;
}
.chat-page > .content > .sidebar {
  width: 25%;
  display: flex;
  flex-direction: column;
}
.chat-page > .content > .message {
  width: 75%;
  height: 100%;
  background-color: rgb(219, 219, 219);
}
.chat-page > .content > .sidebar > .user {
  border-bottom: 2px solid;
  border-top: 2px solid;
  max-height: 200px;
  overflow-y: scroll;
}
.chat-page > .content > .sidebar > .user > .item {
  padding: 5px 5px;
  cursor: pointer;
}
.-online {
  background-color: rgba(96, 255, 91, 0.2);
}
.-offline {
  background-color: rgba(255, 91, 91, 0.2);
}
.-call {
  background-color: rgba(250, 255, 91, 0.2);
}
.chat > .item {
  cursor: pointer;
}
.chat > .item:hover {
  background-color: aliceblue;
}
.chat > .item > .groupName {
  font-weight: 700;
  margin: 2px 0;
}
.chat > .item > .subMessage {
  display: flex;
  margin: 1px 0;
  font-size: 14px;
  color: rgb(49, 49, 49);
  width: 100%;
}
.chat > .item > .subMessage > .message {
  width: 80%;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: "----";
  padding-right: 10px;
  text-overflow: ellipsis;
}
.message,
.message > .contentMessage {
  display: flex;
  height: 95%;
  width: 100%;
  overflow-y: auto;
  flex-direction: column;
  padding-bottom: 20px;
}

.message > .header {
  display: flex;
  padding: 0 20px;
  background-color: aliceblue;
}
.message > .header > .groupName {
  font-size: 20px;
  font-weight: 700;
  margin: 0;
  padding: 10px 0;
  width: 70%;
}
.message > .header > .groupName > .usersGroup {
  font-size: 14px;
  font-weight: 400;
}
.message > .header > .action {
  width: 30%;
  font-size: 33px;
  cursor: pointer;
  text-align: right;
}
.material-symbols-outlined {
  padding: 10px 10px;
}
.message > .inputChat {
  padding: 0 20px;
}
.message > .contentMessage > .item {
  padding: 0 20px;
}
.message > .contentMessage > .item > .left {
  float: left;
  width: auto;
  max-width: 45%;
  display: flex;
}
.message > .contentMessage > .item > .left > .user {
  margin: auto;
}
.message > .contentMessage > .item > .left > .content {
  background-color: rgb(187, 187, 187);
  border-radius: 5px;
  padding: 7px 5px;
  margin: 1px 0;
}

.message > .contentMessage > .item > .right {
  float: right;
  display: flex;
  width: auto;
  max-width: 45%;
}
.message > .contentMessage > .item > .right > .content {
  background-color: rgb(0, 85, 255);
  color: white;
  border-radius: 5px;
  padding: 5px;
  margin: 1px 0;
}
.message > .inputChat > .typing {
  margin: 0;
  font-size: 14px;
}
</style>
