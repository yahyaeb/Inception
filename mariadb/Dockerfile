FROM debian:13

# ENV mariadb_USERNAME=admin \
#     MARIADB_ROOT_PASSWORD=123

#default port 3306
EXPOSE 3306 




RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/lib/mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld

COPY . /home/mariadb

ENTRYPOINT [ "mariadbd" ]
CMD ["--user=mysql", "--datadir=/var/lib/mysql", "--bind-address=0.0.0.0"]