#!/bin/bash

set -v

cd /tmp

# Get pycharm
wget https://download.jetbrains.com/python/pycharm-community-2019.2.4.tar.gz -O pycharm.tar.gz

# Extract
sudo tar -xzf pycharm.tar.gz -C /opt/

# Remove installer
rm pycharm.tar.gz

# Go into new pycharm folder
cd /opt/pycharm-*/bin

# Install pycharm
/bin/sh pycharm.sh