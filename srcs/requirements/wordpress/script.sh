#!/bin/bash
set -e

DOCROOT="/var/www/html"
mkdir -p "$DOCROOT"
cd "$DOCROOT"

# Waiting for database to be ready
echo "Waiting for database to be ready..."
for i in $(seq 1 30); do
  if mysql -h"${MYSQL_HOST:-mariadb}" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1;" 2>/dev/null; then
    echo "Database is ready!"
    break
  else
    echo "Waiting for database... (attempt $i/30)"
    sleep 2
  fi
done

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

# Waiting for database to be ready before installing WordPress
echo "Checking if WordPress is installed..."
for i in $(seq 1 10); do
  if wp core is-installed --allow-root 2>/dev/null; then
    echo "WordPress is already installed."
    break
  else
    echo "Installing WordPress... (attempt $i/10)"
    if wp core install \
      --url="$DOMAIN_NAME" \
      --title="$BRAND" \
      --admin_user="$WORDPRESS_ADMIN" \
      --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
      --admin_email="$WORDPRESS_ADMIN_EMAIL" \
      --allow-root --skip-email 2>/dev/null; then
      
      wp user create "$LOGIN" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PWD" \
        --role=author \
        --allow-root 2>/dev/null || true

      wp config set FORCE_SSL_ADMIN 'false' --allow-root
      echo "WordPress installed successfully!"
      break
    else
      echo "WordPress installation failed, retrying..."
      sleep 3
    fi
  fi
done

chown -R www-data:www-data "$DOCROOT" || true
find "$DOCROOT" -type d -exec chmod 755 {} \; || true
find "$DOCROOT" -type f -exec chmod 644 {} \; || true

exec php-fpm8.2 -F
