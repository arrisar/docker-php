ARG ARCH
ARG PHP_VER
ARG CADDY_VER

FROM caddy:$CADDY_VER as caddy
FROM ${ARCH}arrisar/php:${PHP_VER}

RUN apk add --no-cache supervisor 
RUN mkdir -p /etc/caddy

COPY --chown=www-data:www-data ./Caddyfile /etc/caddy/Caddyfile
COPY --from=caddy --chown=www-data:www-data /usr/bin/caddy /usr/bin/caddy

COPY ./php-fpm.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY ./supervisor.conf /etc/supervisord/supervisor.conf

EXPOSE 80
CMD /usr/bin/supervisord -n -c /etc/supervisord/supervisor.conf