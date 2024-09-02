FROM alpine:3.8

RUN apk add mariadb mariadb-client


RUN chown -R mysql:mysql /var/lib/mysql

RUN mkdir /etc/init.d/mysql \
&& chown -R root:root /etc/init.d/mysql \
&& chmod 777 /etc/init.d/mysql 

RUN mkdir -p /var/run/mysqld \
&& chown -R mysql:mysql /var/run/mysqld \
&& chmod 777 /var/run/mysqld

EXPOSE 3306

COPY ./scripts/mariadb.sh /usr/local/bin/
RUN chown -R mysql:mysql /usr/local/bin/mariadb.sh
RUN chmod +x /usr/local/bin/mariadb.sh

ENTRYPOINT ["/usr/local/bin/mariadb.sh"]

