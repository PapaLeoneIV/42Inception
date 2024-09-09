FROM debian:buster

RUN apt-get update && \
    apt-get install -y vsftpd

COPY ./conf/vsftpd.conf /etc/vsftpd.conf

COPY ./tools/entrypoint.sh /entrypoint.sh

RUN useradd -m ${FTP_USER} && \
    echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd


RUN chmod +x /entrypoint.sh

RUN mv entrypoint.sh /usr/local/bin/

EXPOSE 21

ENTRYPOINT ["/bin/sh", "-c", "/etc/init.d/vsftpd start && tail -f /dev/null"]

