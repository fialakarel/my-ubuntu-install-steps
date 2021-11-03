#!/bin/bash

set -v

# Documentation
# https://docs.microsoft.com/en-gb/dotnet/core/install/linux-ubuntu

cd /tmp

# Get it
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb


# Install
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update
sudo apt install -fy dotnet-runtime-5.0
#sudo apt install -fy dotnet-sdk-5.0        # use this to install .NET SDK

# Cleaning
cd /tmp
rm packages-microsoft-prod.deb
