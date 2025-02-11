# Hibiscus Server Docker

Docker container for [Hibiscus Payment Server](https://www.willuhn.de/products/hibiscus-server/), a Java-based banking server that supports automated transaction retrieval and payment processing.

## Features

- Based on Eclipse Temurin JRE 21 Alpine for modern Java features
- Runs as non-root user
- Uses embedded H2 database
- Persistent data storage
- Configurable version via build argument
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

You can also use a specific version by replacing `latest` with a version tag like `2.10.24`.

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

Note: The container will fail to start if HIBISCUS_PASSWORD is not provided.

## Configuration

### Build Arguments

- `HIBISCUS_VERSION`: Version of Hibiscus Server to install (default: 2.10.24)

### Environment Variables

- `HIBISCUS_PASSWORD`: Password for server access (required)

### Volumes

- `/opt/hibiscus-data`: Contains persistent data including:
  - `.jameica` directory with user data
  - H2 database
  - Configuration files

## Access

The server is accessible via HTTPS on port 8080. Make sure to use `https://` when accessing the server (e.g., `https://localhost:8080/webadmin`).

Default login:

- Username: `admin`
- Password: Value of `HIBISCUS_PASSWORD`

## Building a Different Version

To build a specific version of Hibiscus Server:

```bash
docker build -t hibiscus-server --build-arg HIBISCUS_VERSION=2.10.24 .
```

## Available Tags

The following tags are available from the GitHub Container Registry:

- `latest`: Latest build from the main branch
- `2.10.24`: Specific version releases
- `<sha>`: Specific commit builds

## Security Notes

- The server runs as non-root user 'hibiscus'
- All data is persisted in a Docker volume
- HTTPS is enabled by default
- Sensitive data is stored in the persistent volume
- Images are signed and include SBOM and provenance attestations
