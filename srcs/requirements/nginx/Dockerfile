FROM debian:buster

# install prerequisites
RUN apt-get update && \
  apt-get install -y \
  nginx \
  openssl -y

RUN mkdir -p /etc/ssl/certs/ \
  && mkdir -p /etc/ssl/private/ 


COPY /conf/nginx.conf /etc/nginx/nginx.conf

COPY tools/entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh



ENTRYPOINT [ "entrypoint.sh" ]