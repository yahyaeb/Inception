FROM debian:12.6

EXPOSE 443

# Install nginx + openssl
RUN apt-get update \
 && apt-get install -y --no-install-recommends nginx openssl ca-certificates curl \
 && rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY ssl/certs.sh /usr/local/bin/certs.sh
RUN chmod +x /usr/local/bin/certs.sh \
 && mkdir -p /etc/nginx/ssl /var/www/html \
 && chown -R www-data:www-data /var/www/html

ENTRYPOINT ["/usr/local/bin/certs.sh"]
