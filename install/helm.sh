#!/bin/bash

set -v

# Create dir for bin files
mkdir $HOME/bin

# Get Helm tgz
wget https://get.helm.sh/helm-v3.2.1-linux-amd64.tar.gz -O /tmp/helm.tgz

# Extract helm binary
tar -xzOf /tmp/helm.tgz linux-amd64/helm >$HOME/bin/helm

# Set permissions
chmod +x $HOME/bin/helm

# Cleaning
rm /tmp/helm.tgz
