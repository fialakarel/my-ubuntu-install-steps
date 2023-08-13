#!/bin/bash

set -v

# OpenScad + unzip
sudo apt update
sudo apt install --yes openscad 

# PrusaSlicer
user="$(id --user --name)"
dst="/home/${user}/bin/prusa-slicer"
url="https://github.com/prusa3d/PrusaSlicer/releases/download/version_2.6.0/PrusaSlicer-2.6.0+linux-x64-GTK3-202306191220.AppImage"

# Get it
wget $url -O $dst

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

