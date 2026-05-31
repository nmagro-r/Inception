
# 📖 User Documentation - Inception Stack (nmagro-r)

Available Services:

This infrastructure consists of three essential services configured to run under strict security guidelines:

    NGINX: Secure reverse proxy and web server. It acts as the only entrypoint to our infrastructure, running on Port 443 with TLS v1.2/v1.3 protocols.

    WordPress: The content management system powered by php-fpm on Port 9000.

    MariaDB: Relational database storage on Port 3306.

# Operational Commands

All infrastructure management is fully automated using a Makefile situated in the root directory.
Start the project

To build, configure, and start the containers and networks:
```bash
make

or

make up
Stop the project (Pause)

To stop the containers without removing them:

make stop
Shutdown the project (Remove)

To stop and completely remove all running containers and networks:

make down
View Container Status

To quickly check that all services are up and running properly:

make ps
Show Logs

To inspect real-time standard output and errors from all services:

make logs
Full Cleanup

To clean up everything, including the persistent Docker named volumes:

make clean
```
# Accessing the Platform

Once the containers are verified as active:

    Website Access: Open your web browser and navigate to:
    https://nmagro-r.42.fr

    Administration Panel: To access the WordPress dashboard, go to:
    https://nmagro-r.42.fr/wp-admin

Note: Because our TLS certificates are self-signed for a local environment, your browser will trigger a security warning. You must click "Advanced" and "Proceed to nmagro-r.42.fr" to enter.
Security & Credentials

All sensitive parameters, usernames, and database connection secrets are configured locally on your host environment:

    Main parameters are active in the file: srcs/.env

    Template example variables are defined in: srcs/.env.example

Warning: Ensure your custom srcs/.env file is included in your .gitignore file to prevent leaking credentials into your repository.