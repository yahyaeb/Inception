#!/bin/bash
set -euo pipefail

DOCROOT="/var/www/html"
mkdir -p "$DOCROOT"
cd "$DOCROOT"

command -v wp >/dev/null || { echo "wp-cli not found"; exit 1; }

# 1) Wait for DB
echo "Waiting for database to be ready..."
for i in $(seq 1 30); do
  if mysql -h"${MYSQL_HOST:-mariadb}" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; then
    echo "Database is ready!"
    break
  fi
  echo "Waiting for database... ($i/30)"
  sleep 2
  [ "$i" -eq 30 ] && { echo "DB not reachable"; exit 1; }
done

# 2) Core files
[ -f index.php ] || wp core download --allow-root

# 3) Ensure wp-config exists AND matches env; if stale => recreate
regen_cfg=false
if [ -f wp-config.php ]; then
  read -r CFG_DB CFG_USER CFG_PASS CFG_HOST <<EOF
$(php -r 'include "wp-config.php"; echo DB_NAME," ",DB_USER," ",DB_PASSWORD," ",DB_HOST;')
EOF
  if [ "$CFG_DB" != "$MYSQL_DATABASE" ] || [ "$CFG_USER" != "$MYSQL_USER" ] || \
     [ "$CFG_PASS" != "$MYSQL_PASSWORD" ] || [ "$CFG_HOST" != "${MYSQL_HOST:-mariadb}" ]; then
    echo "wp-config.php does not match env → regenerating"
    regen_cfg=true
  fi
else
  regen_cfg=true
fi

if $regen_cfg; then
  rm -f wp-config.php
  wp config create \
    --dbname="$MYSQL_DATABASE" \
    --dbuser="$MYSQL_USER" \
    --dbpass="$MYSQL_PASSWORD" \
    --dbhost="${MYSQL_HOST:-mariadb}" \
    --dbcharset="utf8mb4" \
    --dbcollate="utf8mb4_unicode_ci" \
    --allow-root --skip-check
  wp config shuffle-salts --allow-root
fi

# 4) Install once (this creates the wp_ tables)
if ! wp core is-installed --allow-root >/dev/null 2>&1; then
  echo "Installing WordPress..."
  wp core install \
    --url="${DOMAIN_NAME}" \
    --title="${BRAND}" \
    --admin_user="${WORDPRESS_ADMIN}" \
    --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root

  # Optional author
  wp user create "$LOGIN" "$WP_USER_EMAIL" \
    --user_pass="$WP_USER_PWD" \
    --role=author \
    --allow-root || true

  # Optional: friendlier local admin over self-signed HTTPS
  wp config set FORCE_SSL_ADMIN false --raw --allow-root
else
  echo "WordPress is already installed."
fi

# 5) Perms (best effort)
chown -R www-data:www-data "$DOCROOT" || true
find "$DOCROOT" -type d -exec chmod 755 {} \; || true
find "$DOCROOT" -type f -exec chmod 644 {} \; || true

# 6) Run FPM
exec php-fpm8.2 -F
