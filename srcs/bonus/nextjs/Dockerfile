FROM debian:buster

RUN apt-get update && apt-get install -y curl build-essential

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=22

RUN bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm use $NODE_VERSION"

RUN bash -c "source $NVM_DIR/nvm.sh && nvm alias default $NODE_VERSION && nvm use default && node -v && npm -v"

WORKDIR /app

COPY app /app

RUN bash -c "source $NVM_DIR/nvm.sh && npm install"

EXPOSE 3000

CMD ["bash", "-c", "source $NVM_DIR/nvm.sh && echo -e '\\e[34m[INFO]\\e[0m Starting on localhost:3000 ...' && npm run dev > /dev/null 2>&1"]

