#!/bin/bash
print_info() {
    echo -e "\e[34m[INFO]\e[0m $1"
}

print_success() {
    echo -e "\e[32m[SUCCESS]\e[0m $1"
}

print_error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
}



print_info "Starting script to configure SSL and Nginx..."

if [[ -z "$DOMAIN_NAME" ]]; then
    print_error "Error: DOMAIN_NAME is not set"
else
    print_info "DOMAIN_NAME is set to $DOMAIN_NAME"
fi

if [[ -z "$P_KEY_" ]]; then
    print_error "Error: P_KEY_ (Private key path) is not set"
else
    print_info "Private key path is set to $P_KEY_"
fi

if [[ -z "$CERTS_" ]]; then
    print_error "Error: CERTS_ (Certificate path) is not set"
else
    print_info "Certificate path is set to $CERTS_"
fi

print_info "Requesting self-signed certificate for $DOMAIN_NAME..."
openssl req -nodes -new -x509 \
    -keyout "$P_KEY_" \
    -out "$CERTS_" \
    -subj "/C=IT/ST=Italy/L=Florence/O=Ecole42/OU=Luiss/CN=$DOMAIN_NAME" > /dev/null 2>&1

if [[ $? -ne 0 ]]; then
    print_error "Error: Failed to generate self-signed certificate!"
else
    print_success "Self-signed certificate generated successfully:"
fi


if [[ -f /etc/nginx/nginx.conf ]]; then
    print_info "Nginx configuration file exists at /etc/nginx/nginx.conf"
else
    print_error "Error: Nginx configuration file not found!"
fi

print_info "Starting Nginx..."
nginx -g "daemon off;"

if [[ $? -ne 0 ]]; then
    print_error "Error: Nginx failed to start!"
    exit 1
else
    print_info "Nginx started successfully."
fi
