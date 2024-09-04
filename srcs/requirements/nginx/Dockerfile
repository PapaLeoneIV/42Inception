FROM debian:buster

# install prerequisites
RUN apt-get update && \
  apt-get install -y \
  nginx \
  openssl -y

COPY /conf/nginx.conf /etc/nginx/sites-available/default

COPY tools/entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]