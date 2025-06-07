# Use build args for target OS/Arch
ARG TARGETOS=linux
ARG TARGETARCH=amd64

# Builder stage: compile Go binary
FROM --platform=${TARGETOS}/${TARGETARCH} golang:1.20 AS builder
WORKDIR /build

# Clone repo and build
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/alireza0/s-ui.git .
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build -ldflags="-s -w" -o s-ui main.go

# Runtime stage: minimal image
FROM --platform=${TARGETOS}/${TARGETARCH} debian:11-slim
ENV DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy compiled binary
COPY --from=builder /build/s-ui /usr/local/bin/s-ui

# Create data directories
RUN mkdir -p /usr/local/s-ui/db /root/cert
WORKDIR /usr/local/s-ui

# Expose ports
EXPOSE 2095 2096 80 443

# Persist database and certificates
VOLUME ["/usr/local/s-ui/db", "/root/cert"]

# Run S-UI
ENTRYPOINT ["/usr/local/bin/s-ui"]
