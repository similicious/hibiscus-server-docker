#!/bin/bash

# Determine protocol based on HTTPS setting
if [ "$HIBISCUS_HTTPS_ENABLED" = "true" ]; then
    PROTOCOL="https"
else
    PROTOCOL="http"
fi

# Try to connect to the Hibiscus Server web interface
if curl -k -f -s --max-time 5 "${PROTOCOL}://localhost:8080/webadmin" > /dev/null; then
    exit 0
else
    exit 1
fi
