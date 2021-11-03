#!/bin/bash

set -v

# Documentation
# https://docs.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.1

cd /tmp

# Get azcopy
curl -L "https://github.com/PowerShell/PowerShell/releases/download/v7.1.5/powershell_7.1.5-1.ubuntu.20.04_amd64.deb" --output powershell.deb

# Install
sudo dpkg -i ./powershell.deb
sudo apt update
sudo apt install -fy

# Cleaning
cd /tmp
rm -rf powershell.dev
