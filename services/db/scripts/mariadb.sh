#!/bin/sh
if docker ps | grep -q "db"; then
    echo "A MariaDB container is already running."
    exit 1
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi


#TODO the mysql process is running in the background, i will need to figure out how to run it in the  without stopping

echo "Starting MariaDB..."
mysqld --user=mysql --datadir=/var/lib/mysql --console &

sleep 5

echo "Securing MySQL installation..."

mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

DELETE FROM mysql.user WHERE User='';

DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost');

DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';

FLUSH PRIVILEGES;
EOF



#questi sono dei check per vedere se eggettivamente il database e l'utente sono stati creati

if [ ! -d "/var/lib/mysql/wordpress" ]; then
    echo "Creating WordPress database..."
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE ${MYSQL_DATABASE};"
fi

if [ -z "$(mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SELECT User FROM mysql.user WHERE User='${MYSQL_USER}'")" ]; then
    echo "Creating WordPress user..."
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"
else
    echo "User ${MYSQL_USER} already exists."
fi

echo "Verifying the creation of the database..."
if mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SHOW DATABASES LIKE '${MYSQL_DATABASE}';" | grep -q "${MYSQL_DATABASE}"; then
    echo "Database ${MYSQL_DATABASE} exists."
else
    echo "Database ${MYSQL_DATABASE} does NOT exist."
fi

echo "Verifying the creation of the user..."
if mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SELECT User FROM mysql.user WHERE User='${MYSQL_USER}'" | grep -q "${MYSQL_USER}"; then
    echo "User ${MYSQL_USER} exists."
else
    echo "User ${MYSQL_USER} does NOT exist."
fi


#viene usato per tenere il processo in vita mentre è in background 
wait

