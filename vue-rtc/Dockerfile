FROM node:14-alpine

WORKDIR /vue-rtc

COPY package*.json ./

COPY . .

EXPOSE 8080


ENTRYPOINT ["sh", "-c", "yarn && yarn serve"]
