FROM debian:buster

RUN apt-get update && \
	apt-get install -y redis \

COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mv entrypoint.sh /usr/local/bin/

EXPOSE 6379

ENTRYPOINT [ "entrypoint.sh" ]
