#!/bin/bash

set -e

echo "[+] Waiting for MariaDB..."
until mysqladmin ping -h mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
    sleep 2
done
echo "[+] MariaDB ready"

cd /var/www/html

if [ ! -f /var/www/html/wp-config.php ]; then

    echo "[+] Fresh install detected, cleaning directory..."
    rm -rf /var/www/html/*

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

exec php-fpm8.2 -F