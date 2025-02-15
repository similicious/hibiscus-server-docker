#!/bin/bash
set -e

# Check for required password
if [ -z "$HIBISCUS_PASSWORD" ]; then
    echo "Error: HIBISCUS_PASSWORD environment variable is required"
    echo "Please run the container with: -e HIBISCUS_PASSWORD=your-password"
    exit 1
fi

# Configure database
if [ "$HIBISCUS_DATABASE" = "h2" ]; then
    # Remove MySQL config to enable H2 auto-setup
    rm -f /opt/hibiscus/cfg/de.willuhn.jameica.hbci.rmi.HBCIDBService.properties
fi

# Create symbolic links for persistent storage
if [ ! -d "/opt/hibiscus-data/.jameica" ]; then
    mkdir -p /opt/hibiscus-data/.jameica
fi

# Link .jameica directory to persistent storage
rm -rf ~/.jameica
ln -s /opt/hibiscus-data/.jameica ~/.jameica

# Start the server with password
cd /opt/hibiscus
exec ./jameicaserver.sh -p "$HIBISCUS_PASSWORD"
