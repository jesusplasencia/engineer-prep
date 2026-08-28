# ==============================================================================
# Multi-Stage Dockerfile for High-Performance Go Microservices
# Features: Go module caching, static binary compilation, Google Distroless base,
# non-root execution, and zero unnecessary runtime dependencies.
# ==============================================================================

# Stage 1: Build binary
FROM golang:1.23-alpine AS builder

WORKDIR /app

# Install git and ca-certificates for fetching dependencies
RUN apk add --no-cache git ca-certificates

# Cache dependencies
COPY go.mod go.sum* ./
RUN go mod download

# Copy source code
COPY . .

# Build statically linked binary with stripped debug symbols
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags="-w -s -extldflags '-static'" \
    -o /bin/server .

# Stage 2: Minimal Distroless Runtime
FROM gcr.io/distroless/static:nonroot

WORKDIR /

# Copy binary and SSL certs from builder
COPY --from=builder /bin/server /server
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Run as non-root user (distroless nonroot UID: 65532)
USER 65532:65532

EXPOSE 8080

ENTRYPOINT ["/server"]

