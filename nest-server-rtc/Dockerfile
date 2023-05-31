FROM node:14-alpine

WORKDIR /nest-server

COPY package*.json ./

COPY . .


EXPOSE 8001


ENTRYPOINT ["sh", "-c", "npm i && npm run start:dev"]
