FROM debian:12

# Base tools + PHP-FPM + required extensions
RUN apt-get update && apt-get install -y \
    ca-certificates curl tar unzip \
    php-fpm php-mysql php-curl php-xml php-mbstring php-zip php-gd \
 && rm -rf /var/lib/apt/lists/*

# wp-cli (single phar)
RUN curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp \
 && chmod +x /usr/local/bin/wp

# Use your pool config (optional; default works too)
COPY fpm-www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Bootstrap script
COPY script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

WORKDIR /home/yel-bouk/data
EXPOSE 9000

# Run php-fpm in foreground via the script (no loops/hacks)
ENTRYPOINT ["/usr/local/bin/script.sh"]
