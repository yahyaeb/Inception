#!/bin/bash
set -e
DOMAIN="cloud1.yahia-cloudonline.xyz"
HOSTS_LINE="127.0.0.1 $DOMAIN"
DATA_DIR="${DATA_DIR:-$HOME/data}"

if ! grep -qE "^[^#]*\b$DOMAIN\b" /etc/hosts; then
  echo "$HOSTS_LINE" | sudo tee -a /etc/hosts >/dev/null
fi

for d in mariadb wordpress nginx; do
  [ -d "$DATA_DIR/$d" ] || mkdir -p "$DATA_DIR/$d"
done
echo "Ready. DATA_DIR=$DATA_DIR"
