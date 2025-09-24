FROM debian:13

# ENV mariadb_USERNAME=admin \
#     MARIADB_ROOT_PASSWORD=123

#default port 3306
# EXPOSE 3306 might be needed to connect with word press 


RUN mkdir -p /home/mariadb
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*


COPY . /home/mariadb

ENTRYPOINT [ "mariadbd" ]