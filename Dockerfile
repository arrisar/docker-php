FROM php:8.0-fpm-buster

LABEL maintainer="james@arrisar.com.au"

#=== Dependencies ===#
RUN \
  apt-get update && \
  apt-get install -y \
    cron \
    libpq-dev \
    nginx \
    supervisor \
    && \
  docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
  docker-php-ext-install \
    pgsql \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    && \
  apt-get autoremove && \
  apt-get clean

#=== Working dirs ===#
RUN rm -rf /var/www/html && \
    mkdir -p /var/www && \
    mkdir -p /var/entrypoints

WORKDIR /var/www

#=== Config and execute ===#
ENV TERM=xterm-256color
ENV TZ=Australia/Melbourne
ENV PATH=$PATH:/var/www/vendor/bin

COPY ./docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf

COPY ./entrypoints /var/entrypoints
RUN chmod -R u+x /var/entrypoints

COPY ./nginx /etc/nginx
COPY ./supervisord.conf /etc/supervisor/

EXPOSE 80
ENTRYPOINT ["/var/entrypoints/php"]
CMD /usr/bin/supervisord -n