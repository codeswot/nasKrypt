#!/bin/bash

# Set the password here
password="your_password_is_not_strong_enough"

# Function to encrypt a file
encrypt_file() {
    local input_file="$1"
    local output_file="${input_file}.enc"

    # Encrypt the file using AES-256 encryption with the embedded password
    openssl enc -aes-256-cbc -salt -in "$input_file" -out "$output_file" -pass pass:"$password"

    echo "File encrypted: $output_file"
}

# Function to decrypt a file
decrypt_file() {
    local input_file="$1"
    local output_file="${input_file%.enc}"

    # Decrypt the file using the embedded password
    openssl enc -d -aes-256-cbc -in "$input_file" -out "$output_file" -pass pass:"$password"

    echo "File decrypted: $output_file"
}

# Main script

# Check for the command argument
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 [encrypt|decrypt] input_file"
    exit 1
fi

command="$1"
input_file="$2"

case "$command" in
    encrypt)
        encrypt_file "$input_file"
        ;;
    decrypt)
        decrypt_file "$input_file"
        ;;
    *)
        echo "Unknown command: $command"
        exit 1
        ;;
esac

exit 0

