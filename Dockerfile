FROM golang as builder

RUN export GO111MODULE=on && \
    go get github.com/mholt/caddy/caddy && \
    mkdir -p /build && \
    cp $GOPATH/bin/caddy /build

FROM alpine
LABEL maintainer="Abreto Fu <m@abreto.net>"

VOLUME [ "/srv" ]
WORKDIR /srv

COPY --from=builder /build/caddy /usr/bin
COPY Caddyfile /etc

RUN apk add --no-cache openssh-client git

EXPOSE 80 443

ENTRYPOINT [ "/usr/bin/caddy", "--conf", "/etc/Caddyfile", "--logs", "stdout" ]
