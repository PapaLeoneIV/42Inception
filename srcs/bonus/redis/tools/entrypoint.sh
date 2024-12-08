#!/bin/bash
INIT_FILE="/etc/redis/redis.conf.tmp"

init_server(){
redis-server --protected-mode no
if [ $? -ne 0 ]; then
    print_error "Failed to start Redis server!"
else
    print_success "Redis server started successfully."
fi
}


if [[ -f "$INIT_FILE" ]]; then
    print_info "Container already initialized. Skipping configuration steps..."
    init_server
    exit 0
fi
# Function to print messages with colors
print_info() {
    echo -e "\e[34m[INFO]\e[0m $1"
}

print_success() {
    echo -e "\e[32m[SUCCESS]\e[0m $1"
}

print_error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
}

if [ ! -f $INIT_FILE ]; then

    cp /etc/redis/redis.conf $INIT_FILE

    sed -i "s|bind 127.0.0.1|#bind 127.0.0.1|g" /etc/redis/redis.conf
    sed -i "s|# maxmemory <bytes>|maxmemory 2mb|g" /etc/redis/redis.conf
    sed -i "s|# maxmemory-policy noeviction|maxmemory-policy allkeys-lru|g" /etc/redis/redis.conf

fi

print_info "Starting Redis server..."

init_server
