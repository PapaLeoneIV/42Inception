FROM debian:buster

ENV FTP_USER=rileone
ENV FTP_PASSWORD=password

RUN apt-get update && \
    apt-get install -y vsftpd

COPY ./conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN mkdir -p /var/share/empty

EXPOSE 21

RUN useradd -m ${FTP_USER} && \
    echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd


ENTRYPOINT ["/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf"]

