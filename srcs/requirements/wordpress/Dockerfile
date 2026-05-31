FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    php \
    php-fpm \
    php-mysql \
    curl \
    mariadb-client \
    ca-certificates  && \
    update-ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

WORKDIR /var/www/html

EXPOSE 9000

# 1. Nos aseguramos de que la carpeta para el socket exista (por si acaso)
RUN mkdir -p /run/php && chown www-data:www-data /run/php

# 2. Cambiamos la configuración de PHP para que escuche en el puerto 9000 en lugar de un socket
RUN find /etc/php -name www.conf -exec sed -i 's/^listen =.*/listen = 9000/' {} +


ENTRYPOINT ["/usr/local/bin/init.sh"]
