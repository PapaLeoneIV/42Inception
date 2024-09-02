#!/bin/sh

SOCKET_FILE=/var/run/mysqld/mysqld.sock

if [ -S "$SOCKET_FILE" ]; then
    echo "MariaDB is already running, proceeding with configuration..."

    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS $MYSQL_USER@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO $MYSQL_USER@'%';"
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

    mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown
else
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    echo "MySQL database initialized"

    echo "Starting MariaDB in the background..."
    mysqld_safe --user=mysql --datadir=/var/lib/mysql &

    until mysqladmin ping --silent; do
        echo "Waiting for MariaDB to start..."
        sleep 2
    done

    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS $MYSQL_USER@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO $MYSQL_USER@'%';"
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

    mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown
fi

echo "Starting MariaDB in the foreground..."
exec mysqld_safe --user=mysql --datadir=/var/lib/mysql

