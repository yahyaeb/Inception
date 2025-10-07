FROM debian:12.6

EXPOSE 3306

# server + client
RUN apt-get update \
 && apt-get install -y --no-install-recommends mariadb-server mariadb-client \
 && rm -rf /var/lib/apt/lists/*


# sane defaults
RUN printf "[mysqld]\nbind-address=0.0.0.0\nskip-name-resolve\nport=3306\n" \
    > /etc/mysql/mariadb.conf.d/99-docker.cnf

# entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["mariadbd","--datadir=/var/lib/mysql","--user=mysql"]
