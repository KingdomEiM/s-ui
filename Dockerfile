# Multi-stage build for S-UI

FROM golang:1.20 AS builder
WORKDIR /build

RUN apt-get update \
    && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

# Clone and compile
RUN git clone https://github.com/alireza0/s-ui.git .
RUN go build -ldflags="-s -w" -o s-ui main.go

# Runtime image
FROM debian:11-slim
ENV DEBIAN_FRONTEND=noninteractive

# Install CA certificates
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy built binary
COPY --from=builder /build/s-ui /usr/local/bin/s-ui

# Create data dirs
RUN mkdir -p /usr/local/s-ui/db /root/cert

WORKDIR /usr/local/s-ui

# Expose ports
EXPOSE 2095 2096 80 443

# Persist DB and certs
VOLUME ["/usr/local/s-ui/db", "/root/cert"]

# Default command
ENTRYPOINT ["/usr/local/bin/s-ui"]
