
# 🛠 Developer Documentation - Inception Stack (nmagro-r)
Technical Specifications:

    Operating System Base: Debian Bookworm (ensuring high stability and system security).

    Network Isolation: Custom bridge network named inception.

    Database Connection: Isolated MariaDB database responding only to private internal requests from the wordpress container on Port 3306.

    PHP Configuration: php-fpm configured to listen on Port 9000.

# Environment Setup

To run, debug, or make changes to this development environment, follow these preparation steps:

    Clone the repository and configure your personal domain inside your VM.

    The Makefile automatically ensures that the required volume storage paths exist on your host machine:
    /home/nmagro-r/data/wordpress
    /home/nmagro-r/data/mariadb

    Copy the template variable configuration file:
    cp srcs/.env.example srcs/.env

    Fill out the environment variables in srcs/.env with your target database credentials, administrative user parameters, and email configuration.

# Service Interconnectivity & DNS

Our multi-container application achieves true service isolation through custom networking:

    Only the NGINX container exposes external ports (Port 443 redirected to the host machine).

    NGINX proxies dynamic requests (.php scripts) through the internal bridge network to the wordpress container via wordpress:9000.

    WordPress performs database transactions by querying the private DB container using mariadb:3306.

    Communication is strictly private. MariaDB cannot be accessed directly from the host system.

# Debugging and Inspection Workflow

During system development, use these operational tools to test behavior:
Status check

# Verify container state, active ports, and current status:
```bash
docker ps

or

make ps
Reading logs

In case of database crashes or NGINX configuration errors, check the logs directly:

make logs
Shell Access

To run direct debugging commands inside any isolated service environment (e.g. NGINX):

docker exec -it nginx sh

To inspect the WordPress PHP setup:

docker exec -it wordpress sh

To run manual SQL queries on the database:

docker exec -it mariadb sh
```
