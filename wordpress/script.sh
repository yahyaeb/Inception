#!/bin/bash
set -e

DOCROOT="/var/www/wordpress"    # <-- align with nginx root
mkdir -p "$DOCROOT"
cd "$DOCROOT"

# (very simple wait – good enough for local)
sleep 10

# 1) Download WP if it's not there yet
if [ ! -f index.php ]; then
  wp core download --allow-root
fi

# 2) Create config if missing
if [ ! -f wp-config.php ]; then
  wp config create \
    --dbname="$database_name" \
    --dbuser="$mysql_user" \
    --dbpass="$mysql_password" \
    --dbhost="$mysql_host" \
    --allow-root --skip-check
fi

# 3) Install if not installed
if ! wp core is-installed --allow-root 2>/dev/null; then
  # WARNING: project forbids admin-like usernames; change if needed
  wp core install \
    --url="$domain_name" \
    --title="$brand" \
    --admin_user="$wordpress_admin" \
    --admin_password="$wordpress_admin_password" \
    --admin_email="$wordpress_admin_email" \
    --allow-root --skip-email

  # author user
  wp user create "$login" "$wp_user_email" \
    --user_pass="$wp_user_pwd" \
    --role=author \
    --allow-root

  # optional tweaks (safe to skip initially)
  wp config set FORCE_SSL_ADMIN 'false' --allow-root
fi

# 4) Permissions (avoid 777)
chown -R www-data:www-data "$DOCROOT" || true
find "$DOCROOT" -type d -exec chmod 755 {} \; || true
find "$DOCROOT" -type f -exec chmod 644 {} \; || true

# 5) Run FPM in foreground (php:8.2-fpm binary is just "php-fpm")
exec php-fpm8.2 -F
