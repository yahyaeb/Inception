FROM debian:13

# ENV MONGO_DB_USERNAME=admin \
#     MONGO_DB_PWD=password

# ENV NGINX_HOST=foobar.com \
#     NGINX_PORT=80

RUN apt-get -y update
RUN apt-get -y install nginx
RUN rm -rf /var/lib/apt/lists/*
RUN mkdir -p /home/app

EXPOSE 443 80
COPY . /home/app

# CMD ["nginx", "-g daemon off"]
ENTRYPOINT ["nginx", "-g daemon off;"]


# FROM : stes the base image
# RUN: Executes the shell commands during build time
# CMD: Provides default command to run at container start
# ENTRYPOINT: Defines a fixed command, often combined with CMD for args
# COPY/ADD: Copies files into the images(ADD support URLS & and archives)
# ENV: Sets environment variables
# EXPOSE: Documents which ports the container will listen on
# WORKDIR: Sets the working directory for following instructions
# VOLUME: Declare mount points for persistent or shared data
# ARG: Defines build-time variables, usuable during RUN

#1 - docker build -t my-nginx:v1 .
#2 - docker run -p 443:80 -d my-nginx:v1
