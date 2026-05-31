*This project has been created as part of the 42 curriculum by nmagro-r.*

# 🐳 Inception - System Administration with Docker

## 📝 Description
Inception is a system administration project focused on infrastructure virtualization. The goal is to build a secure, interconnected environment using **Docker Compose**, where each service (NGINX, WordPress, and MariaDB) is isolated in its own container running on **Debian Bookworm**.

## 📁 Project Structure
```bash
.
├── Makefile                    # Orchestration and build commands
├── README.md                   # This file
├── USER_DOC.md                 # Manual for end-users
├── DEV_DOC.md                  # Technical documentation for developers
└── srcs/
    ├── .env                    # Active configuration (Git-ignored)
    ├── .env.example            # Template for environment variables
    ├── docker-compose.yml      # Container orchestration configuration
    └── requirements/           # Service definitions
        ├── mariadb/            # MariaDB setup (Dockerfile, conf, init.sh)
        ├── nginx/              # NGINX setup (Dockerfile, conf, SSL)
        └── wordpress/          # PHP-FPM & WP-CLI setup
```

# 🚀 Instructions

## Requirements

Docker
Docker Compose

## Setup

### Clone the repository:
```bash
git clone <repository_url>
cd inception

### Create required host directories for persistent storage:

mkdir -p /home/nmagro-r/data/wordpress
mkdir -p /home/nmagro-r/data/mariadb

## Build and Run

### Start the full infrastructure:

make

Or manually:

docker-compose -f srcs/docker-compose.yml up --build -d

### 🛠 Available Commands

make up        # Build and start containers
make down      # Stop and remove containers
make stop      # Stop containers without removing
make start     # Start containers
make restart   # Restart all services
make logs      # Show logs
make ps        # Show running containers
make clean     # Remove containers and volumes
make fclean    # Full system cleanup
make re        # Rebuild everything from scratch
```

# 💡 Project Description & Architecture

The project is composed of three custom-built containers:

NGINX: Handles HTTPS requests and acts as a reverse proxy via Port 443 (TLS v1.2/v1.3 only).

WordPress: Provides dynamic website functionality using PHP-FPM on Port 9000.

MariaDB: Relational database system used by WordPress on Port 3306.

All services communicate through a custom isolated Docker bridge network named inception.

# 🏛 Key Design Choices

## 🖥️ Virtual Machines vs Docker

Virtual Machines: Run a full operating system per instance, leading to heavy resource usage and slow startup times.

Docker: Shares the host OS kernel, making containers lightweight, fast, and highly efficient in resource usage.

Decision: Docker was chosen to achieve rapid deployment, microservice isolation, and high performance.

## 🔑 Secrets vs Environment Variables

Environment Variables: Stored in the .env file and passed at runtime. Perfect for configuration but not fully secure for production.

Docker Secrets: More secure, preventing confidential data from being baked into the images or visible via standard env queries.

Decision: Since this project runs on a single host with standalone Compose, an .env file (correctly git-ignored) is utilized alongside .env.example to demonstrate configuration mechanics securely.

## 🌐 Docker Network vs Host Network

Bridge Network: (Used in this project) Containers communicate through an isolated virtual network bridge. This provides high security, private internal DNS resolution, and strict service separation.

Host Network: Containers share the host's network directly, removing isolation and exposing internal ports unnecessarily.

Decision: A bridge network is implemented to guarantee that only NGINX is exposed to the outside, securing MariaDB and PHP-FPM.

## 💾 Docker Volumes vs Bind Mounts

Docker Named Volumes (Used in this project): Managed entirely by Docker but configured using local driver options to point to /home/nmagro-r/data. This satisfies the subject's rule requiring named volumes while forcing data storage on a specific host path.

Bind Mounts: Directly mount a host directory into the container. However, they bypass Docker's volume management life-cycle and are prohibited by the subject.

Decision: Named volumes with local path mapping are used to ensure the data persists across container teardowns (make down) while strictly complying with the subject's rules.

## 🤖 AI Usage Disclosure

AI assistance was utilized for:

Clarifying internal Docker bridge networking and DNS resolution.

Optimizing Debian Bookworm package installation layers inside the Dockerfiles.

Enhancing documentation structure and formatting for evaluation readiness.

All configuration files, environment variables, and scripts were written and verified manually.

## 📚 Resources

Docker Official Documentation

Docker Compose Reference

MariaDB Server Documentation

WordPress CLI & Configuration

NGINX HTTPS Guide