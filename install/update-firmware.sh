#!/bin/bash

set -v

## How to update firmware
#https://itsfoss.com/update-firmware-ubuntu/

# Install fwupdate
sudo apt update
sudo apt install --yes fwupdate

# Start the service
sudo systemctl start fwupd.service

# Update it
sudo fwupdmgr update
