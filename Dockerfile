# Builder stage: compile Go binary for host architecture
FROM golang:1.20 AS builder
WORKDIR /build

# Clone and build
RUN git clone https://github.com/alireza0/s-ui.git .
RUN go build -ldflags="-s -w" -o s-ui main.go

# Runtime image
FROM debian:11-slim
ENV DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates git && \
    rm -rf /var/lib/apt/lists/*

# Copy binary
COPY --from=builder /build/s-ui /usr/local/bin/s-ui

# Prepare directories
RUN mkdir -p /usr/local/s-ui/db /root/cert
WORKDIR /usr/local/s-ui

# Expose ports
EXPOSE 2095 2096 80 443

# Persist data
VOLUME ["/usr/local/s-ui/db", "/root/cert"]

# Run
ENTRYPOINT ["/usr/local/bin/s-ui"]
