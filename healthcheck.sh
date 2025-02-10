#!/bin/bash

# Try to connect to the Hibiscus Server web interface
if curl -k -f -s --max-time 5 https://localhost:8080/webadmin > /dev/null; then
    exit 0
else
    exit 1
fi
