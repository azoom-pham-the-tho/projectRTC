FROM nginx:1.16

WORKDIR /etc/nginx/conf.d/

COPY .env proxy-script.sh *.htpasswd ./
COPY nginx.conf ./default.conf
RUN chmod a+x ./proxy-script.sh
RUN env $(grep -v '^#' ./.env) ./proxy-script.sh

ENTRYPOINT ["nginx", "-g", "daemon off;"]
