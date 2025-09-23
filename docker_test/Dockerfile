FROM nginx:latest

# ENV MONGO_DB_USERNAME=admin \
#     MONGO_DB_PWD=password

# ENV NGINX_HOST=foobar.com \
#     NGINX_PORT=80

RUN mkdir -p /home/app

COPY . /home/app

# CMD ["nginx", "-g daemon off"]
ENTRYPOINT ["nginx", "-g daemon off;"]