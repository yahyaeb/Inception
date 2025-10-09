#!/bin/sh
set -eu

DATADIR="/var/lib/mysql"
SOCK="/run/mysqld/mysqld.sock"

mkdir -p "$DATADIR" /run/mysqld
chown -R mysql:mysql "$DATADIR" /run/mysqld

# create system tables
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

echo "Ensuring database and user exist..."
mariadbd --user=mysql --datadir="$DATADIR" --socket="$SOCK" --skip-networking &
TMP_PID=$!

for i in $(seq 1 30); do
  mysqladmin --socket="$SOCK" ${MYSQL_ROOT_PASSWORD:+-p"$MYSQL_ROOT_PASSWORD"} ping --silent && break
  sleep 1
done

mysql --socket="$SOCK" -u root ${MYSQL_ROOT_PASSWORD:+-p"$MYSQL_ROOT_PASSWORD"} <<SQL
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
ALTER USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
SQL

mysqladmin --socket="$SOCK" ${MYSQL_ROOT_PASSWORD:+-p"$MYSQL_ROOT_PASSWORD"} shutdown
wait $TMP_PID 2>/dev/null || true

exec mysqld --user=mysql --socket="$SOCK" --datadir="$DATADIR"
