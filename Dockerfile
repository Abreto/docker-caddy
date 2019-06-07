FROM alpine as build

# ENV GO111MODULE=on
# RUN go get github.com/mholt/caddy/caddy && \
#     mkdir -p /build && \
#     cp ${GOPATH}/bin/caddy /build/caddy

# RUN ${GOPATH}/bin/caddy -version && \
#     /build/caddy -version

RUN apk add curl ca-certificates bash
RUN curl https://getcaddy.com | bash -s personal tls.dns.gandi

FROM alpine
LABEL maintainer="Abreto Fu <m@abreto.net>"

VOLUME [ "/srv" ]
WORKDIR /srv

COPY --from=build /usr/local/bin/caddy /usr/local/bin/
COPY Caddyfile /etc/Caddyfile
COPY index.html /srv/index.html

RUN apk add --no-cache openssh-client \
    git \
    curl \
    # tini \
    ca-certificates && \
    chmod +x /usr/local/bin/caddy

EXPOSE 80 443 2015

# ENTRYPOINT [ "/sbin/tini", "--" ]
# CMD [ "/usr/bin/caddy", "--conf", "/etc/Caddyfile", "--logs", "stdout" ]

ENTRYPOINT [ "caddy", "--conf", "/etc/Caddyfile", "--log", "stdout" ]
