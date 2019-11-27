FROM alpine as installer

RUN apk add curl ca-certificates bash && \
    (curl https://getcaddy.com | bash -s personal)

FROM alpine
LABEL maintainer="Abreto FU <m@abreto.net>"

VOLUME [ "/srv" ]
WORKDIR /srv

COPY --from=installer /usr/local/bin/caddy /usr/local/bin/
COPY Caddyfile /.caddy/caddyfilecontainer/
COPY index.html /srv

RUN apk add --no-cache openssh-client \
    git \
    curl \
    ca-certificates

EXPOSE 80 443 2015

ENTRYPOINT [ "sh", "-c", "caddy", "-conf", "/.caddy/caddyfilecontainer/Caddyfile", "-log", "stdout" ]
