FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    mariadb-server \
    mariadb-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Solo creamos las carpetas y damos permisos al usuario mysql, que es quien corre el servicio
RUN mkdir -p /var/run/mysqld /var/log/mysql && \
    chown -R mysql:mysql /var/run/mysqld /var/log/mysql && \
    chmod 777 /var/run/mysqld /var/log/mysql

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

# COMENTA esta línea si sigue dando error, a veces el enlace simbólico da problemas de permisos
# RUN ln -sf /dev/stderr /var/log/mysql/error.log

EXPOSE 3306

CMD ["/usr/local/bin/init.sh"]
