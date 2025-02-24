# Hibiscus Server Docker

Docker image for [Hibiscus Payment Server](https://www.willuhn.de/products/hibiscus-server/), a Java-based banking server that supports automated transaction retrieval and payment processing.

## Features

- Runs as non-root user
- By default uses embedded H2 database
- Hibiscus version configurable via build argument
- Automatic health checking

## Quick Start

### Using Pre-built Image from GitHub Container Registry

1. Pull the image:

```bash
docker pull ghcr.io/similicious/hibiscus-server-docker:latest
```

2. Run the container (password required):

```bash
docker run -d \
  --name hibiscus-server \
  -p 8080:8080 \
  -v hibiscus-data:/opt/hibiscus-data \
  -e HIBISCUS_PASSWORD="your-password" \
  ghcr.io/similicious/hibiscus-server-docker:latest
```

### Building Locally

1. Build the image:

```bash
docker build -t hibiscus-server .
```

2. Run the container (password required):

```bash
docker run -d \
  --name hibiscus-server \
  -p 8080:8080 \
  -v hibiscus-data:/opt/hibiscus-data \
  -e HIBISCUS_PASSWORD="your-password" \
  hibiscus-server
```

Note: The container will fail to start if `HIBISCUS_PASSWORD` is not provided.

## Configuration

### Build Arguments

- `HIBISCUS_VERSION`: Version of Hibiscus Server to build the container for (default: 2.10.24)

### Environment Variables

- `HIBISCUS_PASSWORD`: Password for server access (required)
- `HIBISCUS_DATABASE`: Database type to use (optional, default: "h2")
  - `h2`: Use embedded H2 database (data stored in volume)
  - `mysql`: Use MySQL database (requires configuration file to be mounted)
- `HIBISCUS_HTTPS_ENABLED`: Enable/disable HTTPS (optional, default: "true")
  - When set to "false", the server will use HTTP instead of HTTPS
- `PUID`: User ID for container user (optional, default: 1000)
- `PGID`: Group ID for container user (optional, default: 1000)

### Volumes

- `/opt/hibiscus-data`: Contains persistent data including:
  - `.jameica` directory with user data
  - H2 database
  - Configuration files

## Access

The server is accessible on port 8080. By default, it uses HTTPS (e.g., `https://localhost:8080/webadmin`).
If HTTPS is disabled via `HIBISCUS_HTTPS_ENABLED=false`, use HTTP instead (e.g., `http://localhost:8080/webadmin`).

Default login:

- Username: `admin`
- Password: Value of `HIBISCUS_PASSWORD`

## Building a Different Version

To build the container for a specific version of Hibiscus Server:

```bash
docker build -t hibiscus-server --build-arg HIBISCUS_VERSION=2.10.24 .
```
