# Start from Debian stable
FROM debian:11-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Download and extract the latest AMD64 S-UI binary
RUN curl -sL https://github.com/alireza0/s-ui/releases/latest/download/s-ui_linux_amd64.tar.gz \
    | tar -xz -C /usr/local/bin

# Create data directories
RUN mkdir -p /usr/local/s-ui/db /root/cert

# Set working directory
WORKDIR /usr/local/s-ui

# Expose ports
EXPOSE 2095 2096 80 443

# Mount volumes for database and certificates
VOLUME ["/usr/local/s-ui/db", "/root/cert"]

# Run S-UI binary
ENTRYPOINT ["/usr/local/bin/s-ui"]
