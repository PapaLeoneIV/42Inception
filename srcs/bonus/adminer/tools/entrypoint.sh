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


print_info "Downloading Adminer..."
curl -L -o /adminer-4.8.1.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php

if [[ $? -ne 0 ]]; then
    print_error "Failed to download Adminer!"
else
    print_success "Adminer downloaded successfully."

    mv /adminer-4.8.1.php /var/www/html/adminer-4.8.1.php

    if [[ $? -ne 0 ]]; then
        print_error "Failed to move Adminer!"
    else
        print_success "Adminer moved to /var/www/html/adminer-4.8.1.php successfully."
    fi
fi

# Navigate to the web directory
cd /var/www/html || { print_error "Failed to change directory to /var/www/html"; exit 1; }

#Updating PHP-FPM configuration
print_info "Updating PHP-FPM configuration..."
sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf
if [[ $? -ne 0 ]]; then
    print_error "Failed to update PHP-FPM configuration!"
else
    print_success "PHP-FPM configuration updated successfully."
fi

# Starting PHP-FPM
print_info "Starting PHP-FPM..."
/usr/sbin/php-fpm7.3 -F
if [[ $? -ne 0 ]]; then
    print_error "Failed to start PHP-FPM!"
else
    print_success "PHP-FPM started successfully."
fi