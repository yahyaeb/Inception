#!/bin/bash
set -e

DOCROOT="/var/www/html"
mkdir -p "$DOCROOT"
cd "$DOCROOT"

sleep 10

if [ ! -f index.php ]; then
  wp core download --allow-root
fi

if [ ! -f wp-config.php ]; then
  wp config create \
    --dbname="$MYSQL_DATABASE" \
    --dbuser="$MYSQL_USER" \
    --dbpass="$MYSQL_PASSWORD" \
    --dbhost="${MYSQL_HOST:-mariadb}" \
    --allow-root --skip-check
fi

if ! wp core is-installed --allow-root 2>/dev/null; then
  wp core install \
    --url="$DOMAIN_NAME" \
    --title="$BRAND" \
    --admin_user="$WORDPRESS_ADMIN" \
    --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
    --admin_email="$WORDPRESS_ADMIN_EMAIL" \
    --allow-root --skip-email

  wp user create "$LOGIN" "$WP_USER_EMAIL" \
    --user_pass="$WP_USER_PWD" \
    --role=author \
    --allow-root

  wp config set FORCE_SSL_ADMIN 'false' --allow-root
fi

chown -R www-data:www-data "$DOCROOT" || true
find "$DOCROOT" -type d -exec chmod 755 {} \; || true
find "$DOCROOT" -type f -exec chmod 644 {} \; || true

exec php-fpm8.2 -F
