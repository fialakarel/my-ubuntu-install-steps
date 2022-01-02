#!/bin/bash

set -v

# Create dir for bin files
mkdir $HOME/bin

version="$(curl https://github.com/mltframework/shotcut/releases/latest | cut -d'"' -f2 | egrep -o "[0-9]+\.[0-9]+\.[0-9]+$")"

# Get Shotcut
wget https://github.com/mltframework/shotcut/releases/download/v${version}/shotcut-linux-x86_64-${version//./}.AppImage -O $HOME/bin/shotcut.AppImage

# Set permissions
chmod +x $HOME/bin/shotcut.AppImage
