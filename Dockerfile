FROM alpine:3.17.3 AS builder

ARG MDBOOK_VERSION=0.4.28

WORKDIR /build

RUN apk add --no-cache cargo && \
    wget -O mdbook.tar.gz "https://github.com/rust-lang/mdBook/archive/v$MDBOOK_VERSION.tar.gz" && \
    tar -xzvf mdbook.tar.gz && \
    cd /build/mdBook* && cargo build --release && \
    mv /build/mdBook*/target/release/mdbook /build/mdbook

########## ########## ##########

FROM alpine:3.17.3

COPY --from=builder /build/mdbook /usr/local/bin/mdbook
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN apk add --no-cache libgcc && \
    adduser -D mdbook && \
    chmod +x /docker-entrypoint.sh

USER mdbook
VOLUME ["/book"]
WORKDIR /book
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 3000

