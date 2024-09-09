FROM debian:buster


RUN apt-get update && \
	apt-get install -y curl php-fpm 

RUN mkdir -p /run/php


COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf
COPY ./conf/wp-config.php /
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mv entrypoint.sh /usr/local/bin/


EXPOSE 6969

ENTRYPOINT [ "entrypoint.sh" ]