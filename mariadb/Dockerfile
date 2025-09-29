FROM debian:13

#default port 3306
EXPOSE 3306 


RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/lib/mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld

#initialize database files
RUN mariadb-install-db --user=mysql --datadir=/var/lib/mysql
VOLUME [ "/var/lib/mysql" ]
USER mysql

ENTRYPOINT [ "mariadbd" ]
CMD ["--datadir=/var/lib/mysql", "--bind-address=0.0.0.0"]