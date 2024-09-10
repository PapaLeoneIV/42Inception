FROM debian:buster

RUN apt-get update && \
    apt-get install -y vsftpd

COPY ./conf/vsftpd.conf /etc/vsftpd.conf

COPY ./tools/entrypoint.sh /entrypoint.sh


RUN chmod +x /entrypoint.sh

RUN mv entrypoint.sh /usr/local/bin/

EXPOSE 21

ENTRYPOINT [ "entrypoint.sh" ]

