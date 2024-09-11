FROM debian:buster

# Install required dependencies
RUN apt-get update && apt-get install -y curl build-essential

# Install NVM (Node Version Manager)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

# Set environment variables for NVM
ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=22

# Load NVM and install Node.js 22.x
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm use $NODE_VERSION"

# Ensure Node.js and npm are available in the environment
RUN bash -c "source $NVM_DIR/nvm.sh && nvm alias default $NODE_VERSION && nvm use default && node -v && npm -v"

# Set the working directory
WORKDIR /app

# Copy your application files to the container
COPY app /app

# Install project dependencies using npm
RUN bash -c "source $NVM_DIR/nvm.sh && npm install"

# Expose port 3000 for the app
EXPOSE 3000

# Start the application using npm
CMD ["bash", "-c", "source $NVM_DIR/nvm.sh && npm run dev"]
