#!/bin/bash

DATABASE="data/player.csv"
STATIC_SALT="ArcaeaSecretPassword"

valid_email() {
    local email="$1"
    [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}

valid_password() {
    local password="$1"
    [[ ${#password} -ge 8 && "$password" =~ [a-z] && "$password" =~ [A-Z] && "$password" =~ [0-9] ]]
}

email="$1"
username="$2"
password="$3"

if ! valid_email "$email"; then
    echo "Error: Invalid email format."
    exit 1
fi

if ! valid_password "$password"; then
    echo "Error: Password must be at least 8 characters, include uppercase, lowercase, and a number."
    exit 1
fi

if grep -q "^$email," "$DATABASE"; then
    echo "Error: Email already registered!"
    exit 1
fi

hashed_password=$(echo -n "${STATIC_SALT}${password}" | sha256sum | awk '{print $1}')

echo "$email,$username,$hashed_password" >> "$DATABASE"
