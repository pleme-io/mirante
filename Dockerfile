FROM rust:1.96-alpine AS builder

RUN apk add --no-cache musl-dev build-base

WORKDIR /mirante

COPY . .
RUN cargo build --release --target x86_64-unknown-linux-musl

FROM alpine:3.23 AS runner

RUN apk add --no-cache ca-certificates \
    && addgroup -S b4ngroup && adduser -S b4nuser -G b4ngroup

COPY --from=builder /mirante/target/x86_64-unknown-linux-musl/release/mirante /usr/local/bin/mirante
COPY ./assets/themes /home/b4nuser/.mirante/themes/
RUN chmod +x /usr/local/bin/mirante \
    && chown b4nuser:b4ngroup /usr/local/bin/mirante \
    && chown -R b4nuser:b4ngroup /home/b4nuser/.mirante

USER b4nuser

ENTRYPOINT ["/usr/local/bin/mirante"]
