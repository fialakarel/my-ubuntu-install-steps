#!/bin/bash

set -v

# OpenScad + unzip
sudo apt update
sudo apt install --yes openscad unzip

# PrusaSlicer
tempdir="$(mktemp -d)"
cd $tempdir
user="$(id --user --name)"
dst="/home/${user}/bin/PrusaSlicer"

# Get it
wget https://cdn.prusa3d.com/downloads/drivers/prusa3d_linux_2_3_0.zip -O prusa3d.zip

# Unzip
unzip prusa3d.zip

# Install
mv $(ls PrusaSlicer*.AppImage) $dst
chmod +x $dst

# Writing desktop file
cat <<EOF | sudo tee /usr/share/applications/PrusaSlicer.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=PrusaSlicer
Icon=PrusaSlicer
Exec=${dst}
Keywords=slice;3D;printer;convert;gcode;stl;obj;amf;
StartupNotify=false
StartupWMClass=PrusaSlicer
MimeType=application/sla;model/x-wavefront-obj;model/x-geomview-off;application/x-amf;
Categories=Development;Engineering;
EOF

# Cleaning
cd 
rm -rf $tempdir
