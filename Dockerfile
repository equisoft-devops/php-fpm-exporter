ARG ARCH=amd64
FROM --platform=linux/${ARCH} golang:1.22-alpine AS builder

RUN apk --no-cache add bash make openssl
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=${ARCH} go build -o /php-fpm-exporter ./cmd/php-fpm-exporter

FROM --platform=linux/${ARCH} alpine:3.19
COPY --from=builder /php-fpm-exporter /php-fpm-exporter

ENTRYPOINT ["/php-fpm-exporter"]
