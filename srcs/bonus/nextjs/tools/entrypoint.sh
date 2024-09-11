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


