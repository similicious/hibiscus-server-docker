#!/bin/bash
set -e

# Set user and group (from PUID/PGID env vars)
PUID=${PUID:-1000}
PGID=${PGID:-1000}

echo "Initializing container with PUID: $PUID, PGID: $PGID"

# Create group with specified PGID if it doesn't exist
groupmod -o -g "$PGID" abc

# Update user with specified PUID
usermod -o -u "$PUID" abc

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

# Fix permissions
chown -R abc:abc /opt/hibiscus /opt/hibiscus-data

# Link .jameica directory to persistent storage
rm -rf /home/abc/.jameica
ln -s /opt/hibiscus-data/.jameica /home/abc/.jameica
chown -h abc:abc /home/abc/.jameica

# Start the server with password as the abc user
cd /opt/hibiscus
exec su-exec abc:abc ./jameicaserver.sh -p "$HIBISCUS_PASSWORD"
