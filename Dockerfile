# Multi-arch Dockerfile for php-fpm-exporter
# Build with Buildx for linux/amd64 and linux/arm64
FROM --platform=$BUILDPLATFORM golang:1.22-alpine AS builder

ARG TARGETPLATFORM
ARG TARGETARCH

RUN apk --no-cache add bash make openssl
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH go build -o /php-fpm-exporter ./cmd/php-fpm-exporter

FROM scratch
COPY --from=builder /php-fpm-exporter /php-fpm-exporter

ENTRYPOINT ["/php-fpm-exporter"]
