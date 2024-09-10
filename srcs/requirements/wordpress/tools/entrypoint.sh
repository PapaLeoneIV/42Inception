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


update_wp_config() {
    if grep -q "define('DB_NAME', '')" "$CONFIG_FILE"; then
        print_info "Updating wp-config.php with database credentials..."
        sed -i "s/define('DB_NAME', '')/define('DB_NAME', '$MYSQL_DATABASE')/" $CONFIG_FILE
        sed -i "s/define('DB_USER', '')/define('DB_USER', '$MYSQL_USER')/" $CONFIG_FILE
        sed -i "s/define('DB_PASSWORD', '')/define('DB_PASSWORD', '$MYSQL_PASSWORD')/" $CONFIG_FILE
        sed -i "s/define('DB_HOST', '')/define('DB_HOST', '$MYSQL_HOSTNAME')/" $CONFIG_FILE

        if [[ $? -ne 0 ]]; then
            print_error "Failed to update wp-config.php!"
        else
            print_success "wp-config.php updated successfully."
        fi
    else
        print_info "wp-config.php already contains database credentials. Skipping update."
    fi
}


# Function to start PHP-FPM
start_services() {
    echo -e "Starting PHP-FPM..."
    /usr/sbin/php-fpm7.3 -F
    if [[ $? -ne 0 ]]; then
        print_error "Failed to start PHP-FPM!"
    else
        print_success "PHP-FPM started successfully."
    fi
}

# Check if the container was already initialized
if [[ -f "$INIT_FILE" ]]; then
    print_info "Container already initialized. Skipping configuration steps..."
    # Waiting for MySQL to start
    update_wp_config
    start_services
    exit 0
fi

# Waiting for MySQL to start
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
 Updating wp-config.php with database credentials
print_info "Updating wp-config.php with database credentials..."

# Check if MYSQL_DATABASE is set and not empty
if [[ -n "$MYSQL_DATABASE" ]]; then
    sed -i "s/db/$MYSQL_DATABASE/" wp-config.php
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
    sed -i "s/user/$MYSQL_USER/" wp-config.php
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
    sed -i "s/tmp/$MYSQL_PASSWORD/" wp-config.php
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
    sed -i "s/host/$MYSQL_HOSTNAME/" wp-config.php
    if [[ $? -ne 0 ]]; then
        print_error "Failed to update database host in wp-config.php!"
    else
        print_success "Database host updated in wp-config.php."
    fi
else
    print_error "MYSQL_HOSTNAME environment variable is empty. Skipping update!"
fi


if [[ $? -ne 0 ]]; then
    print_error "Failed to update wp-config.php!"
else
    print_success "wp-config.php updated successfully."
fi

# Installing WordPress
print_info "Installing WordPress..."

echo "DOMAIN_NAME: $DOMAIN_NAME"
echo "WP_TITLE: $WP_TITLE"
echo "WP_ADMIN_USER: $WP_ADMIN_USER"
echo "WP_ADMIN_PASSWORD: $WP_ADMIN_PASSWORD"
echo "WP_ADMIN_EMAIL: $WP_ADMIN_EMAIL"
echo "WP_USER: $WP_USER"
echo "WP_USER_EMAIL: $WP_USER_EMAIL"
echo "WP_USER_PASSWORD: $WP_USER_PASSWORD"


wp core install --url=$DOMAIN_NAME/ --title=$WP_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
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

print_info "Redis Configuration Set Up"
# Ensure Redis cache plugin is installed and activated
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

# Starting services

start_services

echo -e "\n\e[32m--------------------\e[0m"
print_success "Script execution completed!"