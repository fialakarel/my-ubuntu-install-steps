#!/bin/bash

set -v

cd /tmp

# Get awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzip
unzip awscliv2.zip

# Install
sudo ./aws/install

# Cleaning
rm -r ./aws awscliv2.zip
