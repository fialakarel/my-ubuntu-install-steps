#!/bin/bash

set -v

# Documentation
# https://azure.microsoft.com/en-us/features/storage-explorer/#overview
# https://docs.microsoft.com/en-us/azure/storage/common/storage-explorer-troubleshooting?tabs=Windows%2C2004#targz-file

cd /tmp

# Get it
wget 'https://go.microsoft.com/fwlink/?LinkId=722418&clcid=0x409' -O storage-explorer.tar.gz

# Extract
sudo mkdir /opt/StorageExplorer
sudo tar -xzf storage-explorer.tar.gz --directory /opt/StorageExplorer

# Install dependencies
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install --yes dotnet-runtime-3.1

# Writing desktop file
cat <<EOF | sudo tee /usr/share/applications/storage-explorer.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Storage Explorer
Icon=Storage Explorer
Exec=/opt/StorageExplorer/StorageExplorer
Keywords=storage;explorer;microsoft;azure;
StartupNotify=false
StartupWMClass=StorageExplorer
Categories=Development;Engineering;
EOF

# Cleaning
cd /tmp
rm packages-microsoft-prod.deb storage-explorer.tar.gz
