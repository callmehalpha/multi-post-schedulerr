FROM php:8.2-fpm-alpine3.16

ADD ./php/www.conf /usr/local/etc/php-fpm.d/www.conf

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

RUN mkdir -p /var/www/html

# Set permissions
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache \
    && chown -R laravel:laravel /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache


WORKDIR /var/www/html

#RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql
#RUN docker-php-ext-install mysqli
# Install required PHP extensions
RUN apk add --no-cache postgresql-dev \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql mysqli exif \
    && apk add --no-cache postgresql-libs
# Clean up
RUN apk del postgresql-dev
