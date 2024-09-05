FROM debian:buster

RUN apt-get update && apt-get install -y php-fpm php-mysql curl


RUN mkdir -p /run/php


#this will be moved to a script 

COPY ./static/* /var/www/html/
COPY ./conf/wp-config.php /


EXPOSE 9000

COPY ./tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh



#this neeeds to be moved inside a script and will be the last command runned
ENTRYPOINT [ "entrypoint.sh" ]