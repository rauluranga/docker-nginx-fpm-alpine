FROM alpine:3.12

ARG UID=65534
ARG GID=82

RUN apk update \
    && apk add --no-cache nginx=1.18.0-r3 \
    && apk add --no-cache php7-fpm php7-json php7-gd \
    && apk add --no-cache php7-intl php7-opcache php7-pdo_mysql php7-mysqli php7-mysqlnd tzdata \
    && apk add --no-cache php7-tokenizer php7-bcmath php7-mcrypt php7-cli php7-common \
    && apk add --no-cache php7-curl php7-mbstring php7-soap php7-xml php7-xmlrpc php7-xmlreader \
    && apk add --no-cache php7-zip php7-ctype php7-simplexml php7-dom php7-xmlwriter \
    && apk add --no-cache php7-zlib php7-phar php7-openssl php7-session php7-iconv php7-gmp php7-apcu \
    && apk add --no-cache libmcrypt-dev zlib-dev gmp-dev \
    && apk add --no-cache s6 curl zip unzip && apk upgrade --no-cache \
# RUN \
# Install dependencies
# Remove (some of the) default nginx config
    && rm -f /etc/nginx.conf /etc/nginx/conf.d/default.conf /etc/php7/php-fpm.d/www.conf \
    && rm -rf /etc/nginx/sites-* \
# Ensure nginx logs, even if the config has errors, are written to stderr
    && ln -s /dev/stderr /var/log/nginx/error.log \
# Support running s6 under a non-root user
    && mkdir -p /etc/s6/services/nginx/supervise /etc/s6/services/php-fpm7/supervise \
    && mkfifo \
        /etc/s6/services/nginx/supervise/control \
        /etc/s6/services/php-fpm7/supervise/control \
    && chown -R ${UID}:${GID} /etc/s6 /run /var/lib/nginx /var/www \
    && chmod o+rwx /run /var/lib/nginx /var/lib/nginx/tmp

COPY etc/ /etc/

WORKDIR /var/www
# user nobody, group www-data
USER ${UID}:${GID}

EXPOSE 8080

ENTRYPOINT ["/etc/init.d/rc.local"]