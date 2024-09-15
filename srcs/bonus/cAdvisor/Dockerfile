FROM alpine:3.17

RUN apk -U upgrade && apk add --no-cache wget bash

RUN wget -O /usr/local/bin/cadvisor https://github.com/google/cadvisor/releases/download/v0.47.0/cadvisor-v0.47.0-linux-amd64 && \
    chmod +x /usr/local/bin/cadvisor

CMD ["bash", "-c", "echo -e '\\e[34m[INFO]\\e[0m Starting cAdvisor on port 8080...' && /usr/local/bin/cadvisor"]
