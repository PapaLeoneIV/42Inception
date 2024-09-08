FROM debian:buster

RUN		apt-get update
RUN		apt-get install -y redis \
		&& rm -rf /var/lib/apt/lists/*

COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mv entrypoint.sh /usr/local/bin/

EXPOSE 6379

ENTRYPOINT [ "entrypoint.sh" ]