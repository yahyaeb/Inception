#!/bin/bash
set -e

DOMAIN="yel-bouk.42.fr"
HOSTS_LINE="127.0.0.1 $DOMAIN"
DATA_DIR="/home/yel-bouk/data"

echo "🔍 Checking /etc/hosts for $DOMAIN..."
if ! grep -q "$DOMAIN" /etc/hosts; then
    echo "➕ Adding $HOSTS_LINE to /etc/hosts (requires sudo)"
    echo "$HOSTS_LINE" | sudo tee -a /etc/hosts > /dev/null
else
    echo "Host entry already exists."
fi

echo " Checking local data directories..."
mkdir -p "$DATA_DIR"/{mariadb,wordpress}
echo " Created/verified $DATA_DIR structure."

echo " Setup complete! You can now run: make up"
