FROM alpine:latest
RUN apk update && apk upgrade
RUN apk add \
    php82 \
    php82-dom \
    php82-fileinfo \
    php82-json \
    php82-simplexml \
    php82-xmlreader \
    php82-xmlwriter \
    php82-curl \
    php82-gd \
    php82-intl \
    php82-openssl \
    php82-mysqli \
    php82-session \
    php82-zlib \
    php82-bz2 \
    php82-phar \
    php82-zip \
    php82-exif \
    php82-ldap \
    php82-opcache \
    php82-pear \
    php82-dev \
    php82-ctype \
    php82-iconv \
    php82-sodium \
    gcc \
    make \
    autoconf \
    libc-dev \
    pkgconfig \
    fcgi \
    php82-cgi \
    php82-fpm \
    lighttpd
RUN pecl channel-update pecl.php.net
RUN printf "\n" | pecl install apcu
COPY php.ini /etc/php82/php.ini
RUN cd /tmp/ && wget -c https://github.com/glpi-project/glpi/releases/download/10.0.11/glpi-10.0.11.tgz && tar -xvf glpi-10.0.11.tgz && rm glpi-10.0.11.tgz && mv glpi /var/www/html
RUN rm -r /var/www/localhost
COPY downstream.php /var/www/html/inc/downstream.php
RUN mkdir -p /glpi/config
RUN mkdir -p /glpi/logs
RUN mkdir -p /glpi/data
COPY local_define.php /glpi/config/local_define.php
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY mod_fastcgi_fpm.conf /etc/lighttpd/mod_fastcgi_fpm.conf
COPY www.conf /etc/php82/php-fpm.d/www.conf
RUN chown -R nobody:nobody /var/www/html
COPY glpi-start.sh /glpi-start.sh
RUN chmod +x /glpi-start.sh
EXPOSE 80
ENTRYPOINT /glpi-start.sh
