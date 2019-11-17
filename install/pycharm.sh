#!/bin/bash

set -v

cd /tmp

version="2019.2.4"

# Get pycharm
wget https://download.jetbrains.com/python/pycharm-community-${version}.tar.gz -O pycharm.tar.gz

# Extract
sudo tar -xzf pycharm.tar.gz -C /opt/

# Remove installer
rm pycharm.tar.gz

# Go into new pycharm folder
cd /opt/pycharm-*/bin

# Install pycharm
/bin/sh pycharm.sh

# Create launcher
sudo tee /usr/share/applications/pycharm.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=PyCharm
Icon=/opt/pycharm-community-${version}/bin/pycharm.png
Exec=/opt/pycharm-community-${version}/bin/pycharm.sh
Comment=The Drive to Develop
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-pycharm
EOF