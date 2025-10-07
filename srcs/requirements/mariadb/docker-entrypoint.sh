#!/bin/sh
set -eu

DATADIR="/var/lib/mysql"
SOCK="/run/mysqld/mysqld.sock"

mkdir -p "$DATADIR" /run/mysqld
chown -R mysql:mysql "$DATADIR" /run/mysqld

if [ ! -d "$DATADIR/mysql" ]; then
  mariadb-install-db --user=mysql --datadir="$DATADIR" >/dev/null

  BOOTSTRAP_SQL="$(mktemp)"
  {
    echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;"
    echo "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    echo "GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';"
    [ -n "${MYSQL_ROOT_PASSWORD:-}" ] && \
      echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    echo "FLUSH PRIVILEGES;"
  } > "$BOOTSTRAP_SQL"

  mariadbd --bootstrap --user=mysql --datadir="$DATADIR" < "$BOOTSTRAP_SQL"
  rm -f "$BOOTSTRAP_SQL"
fi

exec mysqld --user=mysql --socket="$SOCK" --datadir="$DATADIR"
