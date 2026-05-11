#!/bin/bash
set -e

DATADIR="/var/lib/mysql"
RUNDIR="/run/mysqld"
# Este es nuestro "testigo"
FIRST_RUN_FILE="$DATADIR/.setup_done"

mkdir -p "$DATADIR" "$RUNDIR"
chown -R mysql:mysql "$DATADIR" "$RUNDIR"

# CAMBIO AQUÍ: Solo inicializamos si NO existe nuestro archivo centinela
if [ ! -f "$FIRST_RUN_FILE" ]; then
    echo "[+] Initializing MariaDB for the FIRST time..."
    
    # 1. Instalamos las tablas base si no están
    mysql_install_db --user=mysql --datadir="$DATADIR" > /dev/null

    # 2. Arrancamos temporal para configurar
    mysqld --user=mysql --datadir="$DATADIR" --skip-networking &
    TMP_PID=$!

    until mysqladmin ping >/dev/null 2>&1; do
        sleep 1
    done

    # 3. Configuración SQL (asegúrate de las comillas en ${MYSQL_USER})
    mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    # 4. Creamos el archivo centinela para que la próxima vez se lo salte
    touch "$FIRST_RUN_FILE"
    
    kill "$TMP_PID"
    wait "$TMP_PID"
    echo "[+] MariaDB initialization finished"
else
    echo "[+] MariaDB already configured (Centinel file found)"
fi

# Comando final
exec mysqld --user=mysql --console --bind-address=0.0.0.0
