# Use Eclipse Temurin JRE 21 Alpine for better performance, security and features
FROM eclipse-temurin:21-jre-alpine

# Define build argument for version
ARG HIBISCUS_VERSION=2.10.24

# Add labels for better maintainability
LABEL maintainer="hibiscus-server-docker maintainers"
LABEL description="Hibiscus Payment Server with embedded H2 database"
LABEL version="${HIBISCUS_VERSION}"

# Create abc user and group
RUN addgroup -g 1000 abc && adduser -u 1000 -G abc -h /home/abc -D abc

# Install required packages
RUN apk add --no-cache \
    curl \
    gnupg \
    unzip \
    bash \
    su-exec \
    shadow

# Set working directory
WORKDIR /opt/hibiscus

COPY hibiscus-signing-key.asc /tmp/hibiscus-signing-key.asc

# Download, verify and install Hibiscus Server
RUN gpg --batch --dearmor --output /tmp/hibiscus-server-keyring.gpg /tmp/hibiscus-signing-key.asc \
    && curl -fL -o hibiscus-server.zip https://www.willuhn.de/products/hibiscus-server/releases/hibiscus-server-${HIBISCUS_VERSION}.zip \
    && curl -fL -o hibiscus-server.zip.asc https://www.willuhn.de/products/hibiscus-server/releases/hibiscus-server-${HIBISCUS_VERSION}.zip.asc \
    && gpgv --keyring /tmp/hibiscus-server-keyring.gpg hibiscus-server.zip.asc hibiscus-server.zip \
    && unzip hibiscus-server.zip \
    && mv hibiscus-server/* . \
    && rm -rf hibiscus-server hibiscus-server.zip hibiscus-server.zip.asc \
        /tmp/hibiscus-signing-key.asc /tmp/hibiscus-server-keyring.gpg

# Create directory for persistent data
RUN mkdir -p /opt/hibiscus-data \
    && chown -R abc:abc /opt/hibiscus /opt/hibiscus-data

# Copy entrypoint and healthcheck scripts
COPY entrypoint.sh /
COPY healthcheck.sh /
RUN chmod +x /entrypoint.sh /healthcheck.sh

# Set up volumes for persistence
VOLUME /opt/hibiscus-data

# Expose Hibiscus Server port
EXPOSE 8080


# Environment variables
ENV HIBISCUS_PASSWORD=""
ENV HIBISCUS_DATABASE="h2"
ENV PUID=1000
ENV PGID=1000
ENV HIBISCUS_HTTPS_ENABLED="true"

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD /healthcheck.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
