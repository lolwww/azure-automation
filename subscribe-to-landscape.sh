#!/bin/bash

sudo apt-get update 
sudo apt-get install landscape-client -y
sudo landscape-config --account-name="$1" --computer-title="$(hostname)" --registration-key= --silent
