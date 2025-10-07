FROM debian:12.6

EXPOSE 9000

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates curl unzip \
      php-fpm php-mysql php-curl php-xml php-mbstring php-zip php-gd \
      mariadb-client \
 && rm -rf /var/lib/apt/lists/*

# wp-cli
RUN curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp \
 && chmod +x /usr/local/bin/wp

# PHP-FPM pool
COPY fpm-www.conf /etc/php/8.2/fpm/pool.d/www.conf

# App dir & permissions
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html
WORKDIR /var/www/html

COPY script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

ENTRYPOINT ["/usr/local/bin/script.sh"]
