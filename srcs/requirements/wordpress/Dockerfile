FROM debian:buster

RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    curl \
    mariadb-client \
    php-redis \
    sudo

RUN mkdir -p /var/www/html
RUN mkdir -p /run/php

COPY conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN  touch /var/log/php7.3-fpm.log
RUN  chown www-data:www-data /var/log/php7.3-fpm.log
RUN  chmod 755 /var/log/php7.3-fpm.log

COPY conf/wp-config.php /

COPY tools/entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["entrypoint.sh"]