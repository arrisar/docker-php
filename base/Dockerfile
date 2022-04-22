ARG ARCH
ARG PHP_VER
ARG COMPOSER_VER

FROM composer:$COMPOSER_VER AS composer

FROM ${ARCH}php:${PHP_VER}-fpm-alpine

ENV TERM='xterm-256color'
ENV TZ='Australia/Melbourne'
ENV PATH="$PATH:/var/www/vendor/bin"
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
    && apk add --no-cache \
        bash \
        freetype \
        zip \
        unzip \
        libpq-dev \
        libzip-dev \
        libpng \
        libjpeg-turbo \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev \  
        mariadb-client \ 
    # Redis extension
    && pecl install -o -f redis \
    && docker-php-ext-enable redis \        
    && rm -rf /tmp/pear \
    # lib zip
    && docker-php-ext-configure zip \
    # Misc extensions
    && docker-php-ext-install \
        zip \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        mysqli \
        opcache \
        pcntl \
        bcmath \
        fileinfo \
        exif \        
    # GD image extensions
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NPROC} gd \
    # remove caches
    && apk del -f .build-deps  

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY ./base.ini /usr/local/etc/php/conf.d/base.ini
COPY ./entrypoint /var/entrypoint

RUN mkdir -p /var/www 
WORKDIR /var/www

ENTRYPOINT ["/var/entrypoint"]