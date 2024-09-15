#!/bin/bash

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

if [ ! -f "/etc/redis/redis.conf.tmp" ]; then

    cp /etc/redis/redis.conf /etc/redis/redis.conf.tmp

    sed -i "s|bind 127.0.0.1|#bind 127.0.0.1|g" /etc/redis/redis.conf > /dev/null 2>&1
    sed -i "s|# maxmemory <bytes>|maxmemory 2mb|g" /etc/redis/redis.conf > /dev/null 2>&1
    sed -i "s|# maxmemory-policy noeviction|maxmemory-policy allkeys-lru|g" /etc/redis/redis.conf > /dev/null 2>&1

fi

print_info "Starting Redis server..."
redis-server --protected-mode no > dev/null 2>&1
if [ $? -ne 0 ]; then
    print_error "Failed to start Redis server!"
else
    print_success "Redis server started successfully."
fi