#!/bin/bash

# Access the variable value passed from the Python script
account-name=$1

echo "Subscribing with account-name : $account-name"

sudo apt-get update 
sudo apt-get install landscape-client -y
sudo landscape-config --account-name=accont-name --computer-title="$(hostname)" --registration-key= –silent
