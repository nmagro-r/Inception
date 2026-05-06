#!/bin/bash

set -e

# Si un comando falla, para todo el script
# No continua si algo falla

DATADIR="/var/lib/mysql"
RUNDIR="/run/mysqld"

# datadir->donde vive la base de datos
# rundir->socket y archivos temporales

mkdir -p "$DATADIR" "$RUNDIR"

# crea las carpetas si no existen

chown -R mysql:mysql "$DATADIR" "$RUNDIR"

# Cambia propetario a mysql

chmod 755 "$RUNDIR"

# Permisos: Dueño-> leer/escribir/ejecutar
# otros-> leer/ejecutar

if [ -z "$(ls -A "$DATADIR")" ]; then
    echo "[+] Initializing MariaDB..."
    # Si el directorio está vacio, log informativo.
    
    mysqld --initialize-insecure --user=mysql --datadir="$DATADIR"
    # Crea estructura interna de la BD->tablas del sistema(mysql, users, etc..)
    # Insecure = root sin password inicial

    mysqld --user=mysql --skip-networking --socket="$RUNDIR/mysql.sock" --datadir="$DATADIR" &
    # Arranca MariaDB en segundo plano
    # Skip-networking-> solo local
    # --socket-> comunicación interna

    TMP_PID=$!
    # Guarda PID del proceso

    until mysqladmin --socket="$RUNDIR/mysql.sock" ping >/dev/null 2>&1; do
        sleep 1
    done
    # Espera hasta que MariaDB responda, no continua hasta que esté vivo


    mysql --socket="$RUNDIR/mysql.sock" <<EOF

ALTER USER 'root'@'localhost'
IDENTIFIED VIA mysql_native_password
USING PASSWORD('${MYSQL_ROOT_PASSWORD}');

CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;

    kill "$TMP_PID"
    # Apaga MariadB temporal
    # Ya todo configurado

    wait "$TMP_PID" 2 >/dev/null || true

    echo "[+] MariaDB initialized"

else
    echo "[+] MariaDB already exits, skipping init"
    # Si ya hay datos , no toca nada.
fi

mkdir -p "$RUNDIR"
chown mysql:mysql "$RUNDIR"
chmod 755 "$RUNDIR"

exec mysqld --user=mysql --console --socket="$RUNDIR/mysqld.sock"
# Ejecutamos MariaDB como servicio principal
# exec hace que mysql sea el proceso principal(PID1),
# que docker gestione correctamente,
# y que las señales(stop/restart) funciones bien.
# --console hace que los logs salgan por pantalla
