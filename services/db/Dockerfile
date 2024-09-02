FROM alpine:3.15.0

# install prerequisites
RUN apk update && \
  apk add --no-cache \
  mariadb mariadb-client

  

COPY /conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod 777 /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ] 

EXPOSE 3306
STOPSIGNAL SIGQUIT

VOLUME ["/var/lib/mysql"]
