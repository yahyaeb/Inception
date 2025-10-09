#!/bin/bash
# use with caution. this will clear all images, containers, volumes, and networks.
set -e

echo "!!--!! WARNING: This script is DANGEROUS. !!---!!"
echo "It will delete ALL Docker containers, images, volumes, and networks on your system."
echo
read -p "Are you sure you want to proceed? (yes/[no]): " confirm

if [[ "$confirm" != "yes" ]]; then
  echo "Operation canceled."
  exit 0
fi

echo "Stopping and removing all containers, images, volumes, and networks..."

sudo docker ps -qa | xargs -r sudo docker stop
sudo docker ps -qa | xargs -r sudo docker rm
sudo docker images -qa | xargs -r sudo docker rmi -f
sudo docker volume ls -q | xargs -r sudo docker volume rm
sudo docker network ls -q | grep -vE '^(bridge|host|none)$' | xargs -r sudo docker network rm 2>/dev/null

echo "Cleanup complete. All Docker data has been removed."
