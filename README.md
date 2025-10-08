<p align="center">
    <img src="./srcs/images/Docker_logo.png" alt="Inception Project Architecture" width="200"/>
</p>

# Inception

## Overview

Inception is a system administration and DevOps project, focused on mastering Docker and containerization concepts.
The goal is to build a secure, isolated multi-service infrastructure entirely using Docker Compose, without relying on pre-built images (except for the base distributions).

This project deploys a WordPress website running on Nginx with a MariaDB database, each service running in its own container and managed through Docker networks and volumes.

## Features

- Multi-container setup with Docker Compose
- Nginx reverse proxy (serving WordPress over HTTPS)
- MariaDB database service
- WordPress + PHP-FPM backend
- Persistent storage with mounted volumes
- Environment-based configuration for credentials and security
- Custom Dockerfiles for each service (no pre-built WordPress/Nginx/MariaDB images)

## Getting Started

### Prerequisites

- Docker
- Docker Compose

### Installation

1. `git clone https://github.com/yahyaeb/Inception.git` then `cd Inception`

2. `make up`

3. `docker ps`

## Usage

- Access WordPress at `https://localhost` or `https://yel-bouk.42.fr`
- Environment variables (database credentials, hostnames, etc.) are stored in the .env file and automatically loaded during build time.

## Project Structure

```
.
├── Makefile
├── .gitignore
├── README.md
└── srcs/
    ├── .env
    ├── docker-compose.yml
    ├── images/
    │   └── Docker_logo.png
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   └── docker-entrypoint.sh
        ├── nginx/
        │   ├── Dockerfile
        │   ├── nginx.conf
        │   └── ssl/
        │       └── certs.sh
        └── wordpress/
            ├── Dockerfile
            ├── fpm-www.conf
            └── script.sh


```

## Makefile Commands

| Command       | Description                                       |
| ------------- | ------------------------------------------------- |
| `make up`     | Build and start all containers                    |
| `make down`   | Stop and remove containers, networks, and volumes |
| `make clean`  | Remove images, containers, and volumes            |
| `make restart`| Rebuild everything from scratch                   |


## Security & Configuration

- Self-signed SSL certificate generated during Nginx setup
- All credentials are injected through the .env file (never hard-coded)
- Services communicate through a private Docker network (wpnet)
- Data is persisted in host directories:
/home/lepokile/data/mariadb
/home/lepokile/data/wordpress

## Learning Outcomes

- Through this project, I gained hands-on experience in:
    - Dockerfile creation and image layering
    - Docker Compose orchestration
    - Service networking and isolation
    - Persistent volume management
    - Environment variable management for configuration
    - Automating builds with Makefile