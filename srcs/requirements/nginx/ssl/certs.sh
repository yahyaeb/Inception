#!/bin/sh
set -e

SSL_DIR=/etc/nginx/ssl
CRT="$SSL_DIR/inception.crt"
KEY="$SSL_DIR/inception.key"
DOMAIN="${NGINX_DOMAIN:-localhost}"

mkdir -p "$SSL_DIR"

# Create certs if they don't exist
if [ ! -f "$CRT" ] || [ ! -f "$KEY" ]; then
  echo "Generating self-signed TLS cert for $DOMAIN ..."
  openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout "$KEY" \
    -out "$CRT" \
    -subj "/CN=$DOMAIN" \
    -addext "subjectAltName=DNS:$DOMAIN,IP:127.0.0.1"
fi

exec nginx -g 'daemon off;'
