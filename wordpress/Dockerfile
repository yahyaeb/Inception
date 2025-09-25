FROM debian:13

ENV WORDPRESS_DB_HOST=db
ENV WORDPRESS_DB_USER=yaya
ENV WORDPRESS_DB_PASSWORD=123
ENV WORDPRESS_DB_NAME=yaya_test

#default port 9000:80
EXPOSE 9000


RUN apt-get update && \
    apt-get install php-fpm -y &&\
    apt-get install -y php-mysql php-curl php-xml php-mbstring php-zip php-gd &&\
    rm -rf /var/lib/apt/lists/*
    
# COPY www.conf /etc/php2/php-fpm/pool.d/.
USER www-data
CMD ["php-fpm", "-F"]

# RUN mkdir -p /var/lib/mysql /run/mysqld && \
#     chown -R mysql:mysql /var/lib/mysql /run/mysqld

# #initialize database files
# RUN mariadb-install-db --user=mysql --datadir=/var/lib/mysql
# VOLUME [ "/var/lib/mysql" ]
# USER mysql

# ENTRYPOINT [ "mariadbd" ]
# CMD ["--datadir=/var/lib/mysql", "--bind-address=0.0.0.0"]