#!bin/bash

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

print_info "Creating user $FTP_USER..."
useradd -m $FTP_USER 
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd


print_info "Starting vsftpd..."
/etc/init.d/vsftpd start && tail -f /dev/null
