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

while ! mysqladmin ping -h"$MYSQL_HOSTNAME" --silent; do
    print_info "Waiting for MySQL to start..."
    sleep 1
done



# Downloading wp-cli.phar
print_info "Downloading wp-cli.phar..."
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
if [[ $? -ne 0 ]]; then
    print_error "Failed to download wp-cli.phar!"
else
    print_success "wp-cli.phar downloaded successfully."
fi

print_info "Downloading Adminer..."
curl -L -o /adminer-4.8.1.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php

if [[ $? -ne 0 ]]; then
    print_error "Failed to download Adminer!"
else
    print_success "Adminer downloaded successfully."

    # Move Adminer to /var/www/html and rename it
    mv /adminer-4.8.1.php /var/www/html/adminer-4.8.1.php

    if [[ $? -ne 0 ]]; then
        print_error "Failed to move Adminer!"
    else
        print_success "Adminer moved to /var/www/html/adminer-4.8.1.php successfully."
    fi
fi
# Changing permissions
print_info "Changing permissions on wp-cli.phar..."
chmod +x wp-cli.phar
if [[ $? -ne 0 ]]; then
    print_error "Failed to change permissions on wp-cli.phar!"
else
    print_success "Permissions changed successfully."
fi

# Moving wp-cli.phar to /usr/local/bin/wp
print_info "Moving wp-cli.phar to /usr/local/bin/wp..."
mv wp-cli.phar /usr/local/bin/wp
if [[ $? -ne 0 ]]; then
    print_error "Failed to move wp-cli.phar to /usr/local/bin/wp!"
else
    print_success "wp-cli.phar moved successfully."
fi

# Downloading WordPress core
print_info "Downloading WordPress core..."
wp core download --path=/var/www/html --allow-root
if [[ $? -ne 0 ]]; then
    print_error "Failed to download WordPress core!"
else
    print_success "WordPress core downloaded successfully."
fi

# Navigate to the web directory
cd /var/www/html || { print_error "Failed to change directory to /var/www/html"; exit 1; }

# Removing wp-config-sample.php
print_info "Removing wp-config-sample.php..."
rm wp-config-sample.php
if [[ $? -ne 0 ]]; then
    print_error "Failed to remove wp-config-sample.php!"
else
    print_success "wp-config-sample.php removed."
fi

# Moving wp-config.php
print_info "Moving wp-config.php..."
mv /wp-config.php wp-config.php
if [[ $? -ne 0 ]]; then
    print_error "Failed to move wp-config.php!"
else
    print_success "wp-config.php moved successfully."
fi

# Updating wp-config.php with database credentials
print_info "Updating wp-config.php with database credentials..."
sed -i "s/db/$MYSQL_DATABASE/" wp-config.php
sed -i "s/user/$MYSQL_USER/" wp-config.php
sed -i "s/tmp/$MYSQL_PASSWORD/" wp-config.php
sed -i "s/host/$MYSQL_HOSTNAME/" wp-config.php

if [[ $? -ne 0 ]]; then
    print_error "Failed to update wp-config.php!"
else
    print_success "wp-config.php updated successfully."
fi

# Installing WordPress
print_info "Installing WordPress..."

wp core install --url=$DOMAIN_NAME/ --title=$WP_TITLE --admin_user=$WP_ADMIN_USR --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
if [[ $? -ne 0 ]]; then
    print_error "WordPress installation failed!"
else
    print_success "WordPress installed successfully."
fi

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

print_info "Starting Redis server..."
redis-server --protected-mode no --daemonize yes
if [[ $? -ne 0 ]]; then
    print_error "Failed to start Redis server!"
else
    print_success "Redis server started successfully."
fi

# Ensure Redis cache plugin is installed and activated
wp plugin install redis-cache --activate --allow-root
if [[ $? -ne 0 ]]; then
    print_error "Failed to install or activate Redis cache plugin!"
else
    print_success "Redis cache plugin activated successfully."
fi

# Enable Redis cache
print_info "Enabling Redis cache..."
wp redis enable --force --allow-root 
if [[ $? -ne 0 ]]; then
    print_error "Failed to enable Redis cache!"
else
    print_success "Redis cache enabled successfully."
fi

# Starting PHP-FPM
print_info "Starting PHP-FPM..."
/usr/sbin/php-fpm7.3 -F
if [[ $? -ne 0 ]]; then
    print_error "Failed to start PHP-FPM!"
else
    print_success "PHP-FPM started successfully."
fi

echo -e "\n\e[32m--------------------\e[0m"
print_success "Script execution completed!"