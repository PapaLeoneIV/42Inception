#!/bin/bash

INIT_FILE="/var/www/html/.container_initialized"
CONFIG_FILE="/var/www/html/wp-config.php"

print_info() {
    echo -e "\e[34m[INFO]\e[0m $1"
}

print_success() {
    echo -e "\e[32m[SUCCESS]\e[0m $1"
}

print_error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
}

# Function to start PHP-FPM
start_services() {
    print_info "Starting PHP-FPM..."
    exec /usr/sbin/php-fpm7.3 -F
}

# Waiting for MySQL to start
ping_db(){
    while ! mysqladmin ping -h"$MYSQL_HOSTNAME" --silent; do
    print_info "Waiting for MySQL to start..."
    sleep 1
    done
}


#Check if the container was already initialized
#if [[ -f "$INIT_FILE" ]]; then
#    print_info "Container already initialized. Skipping configuration steps..."
#    ping_db
#    start_services
#    exit 0
#fi


print_info "Downloading WordPress core..."
wp core download --path=/var/www/html --allow-root
if [[ $? -ne 0 ]]; then
    print_error "Failed to download WordPress core!"
else
    print_success "WordPress core downloaded successfully."
fi
print_info "Moving inside /var/www/html..."

mv /wp-config.php $CONFIG_FILE
cd /var/www/html


if [ -f "wp-config-sample.php" ]; then
    rm wp-config-sample.php
    print_info "wp-config-sample.php exists."
else
    print_error "wp-config-sample.php does not exist!"
fi

# Updating wp-config.php with database credentials
print_info "Updating wp-config.php with database credentials..."

# Check if MYSQL_DATABASE is set and not empty
if [[ -n "$MYSQL_DATABASE" ]]; then
    sed -i "s/db/$MYSQL_DATABASE/" $CONFIG_FILE
    if [[ $? -ne 0 ]]; then
        print_error "Failed to update database name in wp-config.php!"
    else
        print_success "Database name updated in wp-config.php."
    fi
else
    print_error "MYSQL_DATABASE environment variable is empty. Skipping update!"
fi

# Check if MYSQL_USER is set and not empty
if [[ -n "$MYSQL_USER" ]]; then
    sed -i "s/user/$MYSQL_USER/" $CONFIG_FILE
    if [[ $? -ne 0 ]]; then
        print_error "Failed to update database user in wp-config.php!"
    else
        print_success "Database user updated in wp-config.php."
    fi
else
    print_error "MYSQL_USER environment variable is empty. Skipping update!"
fi

# Check if MYSQL_PASSWORD is set and not empty
if [[ -n "$MYSQL_PASSWORD" ]]; then
    sed -i "s/tmp/$MYSQL_PASSWORD/" $CONFIG_FILE
    if [[ $? -ne 0 ]]; then
        print_error "Failed to update database password in wp-config.php!"
    else
        print_success "Database password updated in wp-config.php."
    fi
else
    print_error "MYSQL_PASSWORD environment variable is empty. Skipping update!"
fi

# Check if MYSQL_HOSTNAME is set and not empty
if [[ -n "$MYSQL_HOSTNAME" ]]; then
    sed -i "s/host/$MYSQL_HOSTNAME/" $CONFIG_FILE
    if [[ $? -ne 0 ]]; then
        print_error "Failed to update database host in wp-config.php!"
    else
        print_success "Database host updated in wp-config.php."
    fi
else
    print_error "MYSQL_HOSTNAME environment variable is empty. Skipping update!"
fi

# Installing WordPress
print_info "Installing WordPress..."
wp core install --url=$DOMAIN_NAME/ --title=$WP_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
if [[ $? -ne 0 ]]; then
    print_error "WordPress installation failed!"
else
    print_success "WordPress installed successfully."
fi


#rm /var/www/html/wp-content/object-cache

# Creating a new WordPress admin
print_info "Creating a WordPress admin..."
wp user create $WP_ADMIN_USER $WP_ADMIN_EMAIL --role=administrator --user_pass=$WP_ADMIN_PASSWORD --allow-root
if [[ $? -ne 0 ]]; then
    print_error "Failed to create the WordPress admin! Already exists probably ..."
else
    print_success "New WordPress admin created successfully."
fi

# Creating a new WordPress user
print_info "Creating a new WordPress user..."
wp user create $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD --allow-root
if [[ $? -ne 0 ]]; then
    print_error "Failed to create the WordPress user! Already exists probably ..."
else
    print_success "New WordPress user created successfully."
fi


# Updating PHP-FPM configuration
print_info "Updating PHP-FPM configuration..."
sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf
if [[ $? -ne 0 ]]; then
    print_error "Failed to update PHP-FPM configuration!"
else
    print_success "PHP-FPM configuration updated successfully."
fi


## Ensure Redis cache plugin is installed and activated
print_info "Redis Configuration Set Up"
wp plugin install redis-cache --activate --allow-root
if [[ $? -ne 0 ]]; then
    print_error "Failed to install or activate Redis cache plugin!"
else
    print_success "Redis cache plugin activated successfully."
fi

wp plugin update --all --allow-root
if [[ $? -ne 0 ]]; then
    print_error "Failed to update plugins!"
else
    print_success "Plugins updated successfully."
fi

# Enable Redis cache
print_info "Enabling Redis cache..."
wp redis enable --force --allow-root
if [[ $? -ne 0 ]]; then
    print_error "Failed to enable Redis cache!" 
else
    print_success "Redis cache enabled successfully."
fi

# Mark the container as initialized
touch "$INIT_FILE"
print_success "Container initialized successfully."

print_success "Script execution completed!"
exec /usr/sbin/php-fpm7.3 -F

