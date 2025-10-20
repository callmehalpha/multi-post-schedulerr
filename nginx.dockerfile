FROM nginx:stable-alpine

LABEL maintainer="SocialHub DevOps"

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

RUN addgroup -g 1000 laravel \
    && adduser -G laravel -g laravel -s /bin/sh -D laravel \
    && mkdir -p /var/www/html \
    && chown -R laravel:laravel /var/www/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
