FROM alpine as installer

RUN apk add curl ca-certificates bash && \
    (curl https://getcaddy.com | bash -s personal)

FROM alpine
LABEL maintainer="Abreto FU <m@abreto.net>"

VOLUME [ "/srv" ]
WORKDIR /srv

ENV CADDYPATH=/var/opt/caddy
VOLUME ${CADDYPATH}/acme


RUN apk add --no-cache openssh-client \
    git \
    curl \
    ca-certificates

COPY --from=installer /usr/local/bin/caddy /usr/local/bin/
COPY Caddyfile /etc/caddy/
COPY index.html /srv

EXPOSE 80 443 2015

ENTRYPOINT [ "caddy", "-conf", "/etc/caddy/Caddyfile", "-log", "stdout" ]
