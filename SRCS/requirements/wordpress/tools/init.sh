#!/bin/bash

set -e

# Si algo falla, el script se detiene

echo "[+] Waiting for MariaDB..."

until mysqladmin ping -h"mariadb" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
    sleep 2
done

echo "[+] MariaDB is ready"

cd /var/www/html

# Si WordPress no está instalado
if [ ! -f wp-config.php ]; then

    echo "[+] Downloading WordPress..."
    wp core download --allow-root

    echo "[+] Creating wp-config.php..."
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb \
        --allow-root

    echo "[+] Installing WordPress..."
    wp core install \
        --url=$DOMAIN_NAME \
        --title="$WP_TITLE" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root

    echo "[+] Creating additional user..."
    wp user create $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --allow-root

else
    echo "[+] WordPress already installed"
fi

echo "[+] Starting PHP-FPM..."

exec php-fpm8.2 -F
