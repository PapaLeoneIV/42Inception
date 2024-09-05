#!/bin/bash


echo "Requesting self signed certificate for $DOMAIN_NAME"
openssl req  -nodes -new -x509  \
    -keyout $P_KEY_ \
    -out $CERTS_ \
    -subj "/C=IT/ST=Italy/L=Florence/O=Ecole42/OU=Luiss/CN=$DOMAIN_NAME"


ls -l /var/www/html




echo "Starting Nginx"

nginx -g "daemon off;"