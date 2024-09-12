#!/bin/sh

SOCKET_FILE=/var/run/mysqld/mysqld.sock

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

# Function to execute a MySQL command and check for errors
execute_mysql_command() {
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "$1" > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        print_error "MySQL command failed: $1"
    else
        print_success "MySQL command executed successfully: $1"
    fi
}

# Check if MariaDB socket file exists, indicating that the service is running
if [ -S "$SOCKET_FILE" ]; then
    print_info "MariaDB is already running, proceeding with configuration..."

    # Create database, user, and grant privileges
    execute_mysql_command "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
    execute_mysql_command "CREATE USER IF NOT EXISTS $MYSQL_USER@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    execute_mysql_command "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO $MYSQL_USER@'%';"
    execute_mysql_command "FLUSH PRIVILEGES;"

    print_info "Shutting down MariaDB..."
    mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown > /dev/null 2>&1
else
    print_info "MariaDB is not running. Initializing data directory..."

    # Initialize the MariaDB data directory
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        print_error "Failed to initialize MariaDB data directory."
        exit 1
    else
        print_success "MariaDB data directory initialized."
    fi

    print_info "Starting MariaDB in the background..."
    mysqld_safe --user=mysql --datadir=/var/lib/mysql > /dev/null 2>&1 &
    sleep 5
    
    until mysqladmin ping --silent > /dev/null 2>&1; do
        print_info "Waiting for MariaDB to start..."
        sleep 2
    done

    print_success "MariaDB started."

    execute_mysql_command "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
    execute_mysql_command "CREATE USER IF NOT EXISTS $MYSQL_USER@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    execute_mysql_command "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO $MYSQL_USER@'%';"
    execute_mysql_command "FLUSH PRIVILEGES;"

    print_info "Shutting down MariaDB..."
    mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown > /dev/null 2>&1
fi

print_info "Starting MariaDB in the foreground..."
exec mysqld_safe --user=mysql --datadir=/var/lib/mysql
