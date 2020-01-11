#!/bin/bash

set -ve

cd /tmp

# Install requirements
sudo apt install --yes git build-essential python3-dev libdbus-glib-1-dev libgirepository1.0-dev libcairo2-dev python3-venv python3-wheel

# Get throttling-fix
git clone https://github.com/erpalma/lenovo-throttling-fix.git

# Install it
sudo ./lenovo-throttling-fix/install.sh

# Cleaning
rm -rf lenovo-throttling-fix
