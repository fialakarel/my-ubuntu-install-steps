#!/bin/bash

set -v

user="$(id --user --name)"
dst="/home/${user}/bin/lens.AppImage"

# Create dir for bin files
mkdir $HOME/bin

version="$(curl https://github.com/lensapp/lens/releases/latest | cut -d'"' -f2 | egrep -o "[0-9]+\.[0-9]+\.[0-9]+$")"

# Get Lens AppImage
wget https://github.com/lensapp/lens/releases/download/v${version}/Lens-${version}.x86_64.AppImage -O $dst

# Set permissions
chmod +x $dst

# Writing desktop file
cat <<EOF | sudo tee /usr/share/applications/Lens.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Lens
Icon=Lens
Exec=${dst}
Keywords=k8s;kubernetes;
StartupNotify=false
StartupWMClass=Lens
Categories=Development;Engineering;
EOF