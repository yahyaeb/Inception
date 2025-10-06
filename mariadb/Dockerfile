FROM debian:13

EXPOSE 3306

# install server + gosu (to drop privileges at the end)
RUN apt-get update \
 && apt-get install -y mariadb-server gosu \
 && rm -rf /var/lib/apt/lists/*

# copy our tiny entrypoint and make it executable
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# persist data
VOLUME ["/var/lib/mysql"]

# IMPORTANT: run as root so we can initialize, then we exec as mysql in the script
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["mariadbd","--datadir=/var/lib/mysql","--bind-address=0.0.0.0"]
