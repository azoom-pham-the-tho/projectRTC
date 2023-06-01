FROM node:14-alpine

WORKDIR /vue-rtc

COPY package*.json ./

COPY . .

EXPOSE 8080


ENTRYPOINT ["sh", "-c", "npm i  && npm run serve"]
