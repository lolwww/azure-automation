#!/bin/bash

# Access the variable value passed from the Python script
token=$1

echo "Subscribing with token: $token"

sudo pro attach $token
