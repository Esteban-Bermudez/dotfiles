#!/bin/bash

result=$(dark-notify)  # Assuming dark-notify outputs either "light" or "dark"

if [ "$result" == "light" ]; then
    echo "0"
else
    echo "1"
fi

