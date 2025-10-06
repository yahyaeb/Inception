#!/usr/bin/env bash
set -euo pipefail

# ensure dirs/ownership (run as root)
mkdir -p /var/lib/mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

# first-run init?
if [ ! -d /var/lib/mysql/mysql ]; then
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/dev/null
  # start temp server (no networking)
  mysqld --skip-networking --socket=/run/mysqld/mysqld.sock --datadir=/var/lib/mysql &
  pid=$!
  # wait for socket
  for i in {1..60}; do [ -S /run/mysqld/mysqld.sock ] && break; sleep 0.5; done

  mysql --protocol=socket -uroot <<SQL
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE:-wordpress}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER:-wpuser}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD:-wppass}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE:-wordpress}\`.* TO '${MYSQL_USER:-wpuser}'@'%';
FLUSH PRIVILEGES;
SQL

  mysqladmin --protocol=socket -uroot shutdown
  wait $pid
fi

# exec real server as mysql
exec gosu mysql "$@"
