# Use Eclipse Temurin JRE 21 Alpine for better performance, security and features
FROM eclipse-temurin:21-jre-alpine

# Define build argument for version
ARG HIBISCUS_VERSION=2.10.24

# Add labels for better maintainability
LABEL maintainer="hibiscus-server-docker maintainers"
LABEL description="Hibiscus Payment Server with embedded H2 database"
LABEL version="${HIBISCUS_VERSION}"

# Create non-root user
RUN addgroup -S hibiscus && adduser -S -G hibiscus hibiscus

# Install required packages
RUN apk add --no-cache \
    curl \
    unzip \
    bash

# Set working directory
WORKDIR /opt/hibiscus

# Download and install Hibiscus Server
RUN curl -L -o hibiscus-server.zip https://www.willuhn.de/products/hibiscus-server/releases/hibiscus-server-${HIBISCUS_VERSION}.zip \
    && unzip hibiscus-server.zip \
    && mv hibiscus-server/* . \
    && rm -rf hibiscus-server hibiscus-server.zip

# Create directory for persistent data
RUN mkdir -p /opt/hibiscus-data \
    && chown -R hibiscus:hibiscus /opt/hibiscus /opt/hibiscus-data

# Copy entrypoint and healthcheck scripts
COPY entrypoint.sh /
COPY healthcheck.sh /
RUN chmod +x /entrypoint.sh /healthcheck.sh

# Set up volumes for persistence
VOLUME /opt/hibiscus-data

# Expose Hibiscus Server port
EXPOSE 8080

# Switch to non-root user
USER hibiscus

# Environment variables
ENV HIBISCUS_PASSWORD=""
ENV HIBISCUS_DATABASE="h2"

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD /healthcheck.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
