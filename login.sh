#!/bin/bash

DATABASE="data/player.csv"
STATIC_SALT="ArcaeaSecretPassword"

email="$1"
password="$2"

if [ ! -f "$DATABASE" ]; then
    echo "Error: No registered users found. Please register first."
    exit 1
fi

hashed_password=$(echo -n "${STATIC_SALT}${password}" | sha256sum | awk '{print $1}')

data_hash=$(awk -F ',' -v email="$email" '$1 == email {print $3}' "$DATABASE")

if [ "$hashed_password" == "$data_hash" ]; then
    echo "Login successful!"

    ./scripts/core_monitor.sh

else
    echo "Error: Incorrect password!"
    exit 1
fi

