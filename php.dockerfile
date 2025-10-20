# syntax=docker/dockerfile:1.4
FROM php:8.2-fpm-alpine3.18

LABEL maintainer="SocialHub DevOps" \
      org.opencontainers.image.source="https://example.com/socialhub"

ENV COMPOSER_ALLOW_SUPERUSER=1 \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=1 \
    PHP_MEMORY_LIMIT=512M

# Install system dependencies and PHP extensions required by Laravel 9+
RUN apk update \
    && apk add --no-cache \
        bash \
        git \
        curl \
        icu-dev \
        libpq \
        libzip \
        libzip-dev \
        oniguruma-dev \
        openssl \
        postgresql-libs \
        shadow \
        sqlite-libs \
        freetype \
        freetype-dev \
        libpng \
        libpng-dev \
        libjpeg-turbo \
        libjpeg-turbo-dev \
        zip \
        unzip \
        zlib \
        zlib-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" \
        bcmath \
        exif \
        gd \
        intl \
        opcache \
        pcntl \
        pdo \
        pdo_pgsql \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del freetype-dev libpng-dev libjpeg-turbo-dev libzip-dev icu-dev oniguruma-dev

# Copy Composer from the official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy FPM pool configuration
COPY ./php/www.conf /usr/local/etc/php-fpm.d/www.conf

# Create application user
RUN addgroup -g 1000 laravel \
    && adduser -G laravel -g laravel -s /bin/sh -D laravel \
    && usermod -aG www-data laravel

WORKDIR /var/www/html

# Ensure storage directories exist with writable permissions
RUN mkdir -p storage bootstrap/cache \
    && chown -R laravel:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# Copy php.ini overrides if provided
COPY php/php.ini /usr/local/etc/php/conf.d/99-custom.ini

EXPOSE 9000

USER laravel

CMD ["php-fpm"]
