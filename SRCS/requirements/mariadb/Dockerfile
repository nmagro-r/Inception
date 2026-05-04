FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Evita prompts interactivos durante la instalación de paquetes

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    mariadb-server \
    mariadb-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Actualizamos la lista de paquetes disponibles en Debian
# Instalamos paquetes SIN extras innecesarios
# Instalamos el servidor de la BD Mariadb y el cliente para ejecutar
# Limpiamos archivos temporales para reducir el tamaño de la imagen Docker

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Archivo de configuración donde defino: que IP escucha, que puerto usa, donde guarda datos, seguridad, logs, etc..
# Copia la configuración personalizada de MariaDB (necesaria para permitir conexiones externas)

COPY tools/init.sh /usr/local/bin/init.sh

# Que hace: copia tú script dentro del contenedor
# Ese script: crea BD, crea usuarios, usa variables de entorno. Mariadb NO lo hace automaticamente.
# Copia el script que inicializa y arranca MariaDB

RUN chmod +x /usr/local/bin/init.sh

# Permisos: Sin esto no podremos ejecutar el script 
# Permisos de ejecución al script

EXPOSE 3306

# Mariadb escucha en el puerto 3306
# Indica que el contenedor usa el puerto 3306 (MariaDB)

CMD ["/usr/local/bin/init.sh"]

# Ejecuta el script de inicializacion al arrancar el contenedor
