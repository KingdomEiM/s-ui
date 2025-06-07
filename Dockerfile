# Base image with systemd support
FROM debian:11-slim

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages including systemd
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       git curl ca-certificates systemd \
    && rm -rf /var/lib/apt/lists/*

# Create a dedicated user for S-UI
RUN useradd -m -s /bin/bash suiuser

# Set working directory
WORKDIR /usr/local/s-ui

# Copy entire repository contents
COPY . .

# Ensure installation and service scripts are executable
RUN chmod +x install.sh runSUI.sh s-ui.sh

# Run the installer script
RUN bash install.sh

# Enable the s-ui systemd service
RUN systemctl enable s-ui

# Expose necessary ports
EXPOSE 2095 2096 80 443

# Persist database and certificate directories
VOLUME ["/usr/local/s-ui/db", "/root/cert"]

# Use systemd as entrypoint
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
