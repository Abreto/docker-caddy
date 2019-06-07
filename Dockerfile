FROM alpine as build

RUN apk add curl ca-certificates bash
RUN curl https://getcaddy.com | bash -s personal tls.dns.gandi

FROM alpine
LABEL maintainer="Abreto Fu <m@abreto.net>"

ENV ACME_AGREE="false"

VOLUME [ "/srv" ]
WORKDIR /srv

COPY --from=build /usr/local/bin/caddy /usr/local/bin/
COPY Caddyfile /etc
COPY index.html /srv

RUN apk add --no-cache openssh-client \
    git \
    curl \
    ca-certificates

EXPOSE 80 443 2015

ENTRYPOINT [ "sh", "-c", "caddy", "-agree=$ACME_AGREE", "-conf", "/etc/Caddyfile", "-log", "stdout" ]
