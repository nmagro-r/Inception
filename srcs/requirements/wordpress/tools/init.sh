#!/bin/bash
set -e

# Esperar a MariaDB
echo "[+] Waiting for MariaDB..."
until mysqladmin ping -h mariadb --silent; do
    sleep 2
done
echo "[+] MariaDB ready"

# Asegurarnos de que estamos en el sitio correcto
cd /var/www/html

if [ ! -f wp-config.php ]; then
    echo "[+] Fresh install detected..."
    
    # Descargar WordPress si no está (sin borrar todo por si acaso hay carpetas de Docker)
    wp core download --allow-root

    # Crear el config
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb:3306 \
        --allow-root --force

    # Instalar WordPress
    # IMPORTANTE: Asegúrate de que $DOMAIN_NAME tiene el https://
    wp core install \
        --url="https://$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root

    # Crear usuario extra
    wp user create $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=author \
        --allow-root
    
    echo "[+] WordPress installed successfully!"
else
    echo "[+] WordPress already configured."
fi

# EL CAMBIO CLAVE: Permisos para que Nginx/PHP puedan leer los archivos
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Iniciar PHP-FPM
echo "[+] Starting PHP-FPM..."
exec php-fpm8.2 -F