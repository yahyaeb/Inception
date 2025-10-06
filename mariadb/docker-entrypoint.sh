#!/usr/bin/env bash
set -euo pipefail

DATADIR="/var/lib/mysql"
SOCK="/run/mysqld/mysqld.sock"

mkdir -p "$DATADIR" /run/mysqld
chown -R mysql:mysql "$DATADIR" /run/mysqld

first_boot=0
if [ ! -d "$DATADIR/mysql" ]; then
  first_boot=1
  echo "[entrypoint] Initializing datadir…"
  mariadb-install-db --user=mysql --datadir="$DATADIR" >/dev/null
fi

if [ "$first_boot" -eq 1 ]; then
  echo "[entrypoint] Bootstrapping users/db…"
  # start temporary local server (socket only)
  mysqld --skip-networking --socket="$SOCK" --datadir="$DATADIR" --user=mysql &
  pid=$!

  # wait until the server answers (not just socket exists)
  for i in $(seq 1 60); do
    if mysqladmin --protocol=socket --socket="$SOCK" ping &>/dev/null; then
      break
    fi
    sleep 0.5
  done
  mysqladmin --protocol=socket --socket="$SOCK" ping >/dev/null

  # create db/user from env (fallbacks for local testing)
  : "${MYSQL_DATABASE:=wordpress}"
  : "${MYSQL_USER:=wpuser}"
  : "${MYSQL_PASSWORD:=wppass}"
  # optional root password; if not set, leave plugin auth
  MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD:-}"

  SQL_FILE=$(mktemp)
  {
    echo "FLUSH PRIVILEGES;"
    echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;"
    echo "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    echo "GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';"
    if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
      # Allow root over % for dev; tighten for prod if you like.
      echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
      echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;"
    fi
    echo "FLUSH PRIVILEGES;"
  } > "$SQL_FILE"

  # Execute SQL with retry logic for reliability
  for i in $(seq 1 5); do
    if mysql --protocol=socket --socket="$SOCK" -uroot < "$SQL_FILE" 2>/dev/null; then
      echo "[entrypoint] Database and user created successfully"
      break
    else
      echo "[entrypoint] Database creation attempt $i failed, retrying..."
      sleep 2
    fi
  done
  
  rm -f "$SQL_FILE"

  mysqladmin --protocol=socket --socket="$SOCK" -uroot shutdown
  wait "$pid"
fi

echo "[entrypoint] Starting MariaDB…"

# Always ensure database and user exist (robust initialization)
ensure_db_user() {
  echo "[entrypoint] Ensuring database and user exist..."
  
  # Wait for MariaDB to be ready
  for i in $(seq 1 30); do
    if mysqladmin --protocol=socket --socket="$SOCK" ping &>/dev/null; then
      break
    fi
    sleep 1
  done
  
  # Create database and user if they don't exist
  : "${MYSQL_DATABASE:=wordpress}"
  : "${MYSQL_USER:=wpuser}"
  : "${MYSQL_PASSWORD:=wppass}"
  MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD:-}"
  
  SQL_FILE=$(mktemp)
  {
    echo "FLUSH PRIVILEGES;"
    echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;"
    echo "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    echo "GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';"
    if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
      echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
      echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;"
    fi
    echo "FLUSH PRIVILEGES;"
  } > "$SQL_FILE"
  
  # Execute with retry logic
  for i in $(seq 1 5); do
    if mysql --protocol=socket --socket="$SOCK" -uroot < "$SQL_FILE" 2>/dev/null; then
      echo "[entrypoint] Database and user ensured successfully"
      break
    else
      echo "[entrypoint] Database setup attempt $i failed, retrying..."
      sleep 2
    fi
  done
  
  rm -f "$SQL_FILE"
}

# Start MariaDB in background and ensure database setup
mysqld --user=mysql --socket="$SOCK" --datadir="$DATADIR" &
DB_PID=$!

# Ensure database and user exist
ensure_db_user

# Wait for the background process
wait $DB_PID
