#!/bin/bash

set -v

# PrusaSlicer
user="$(id --user --name)"
dst="/home/${user}/bin/RepetierHost"

wget https://download3.repetier.com/files/host/linux/Repetier-Host-x86_64-2.1.6.AppImage -O $dst
chmod +x $dst

# Writing desktop file
cat <<EOF | sudo tee /usr/share/applications/RepetierHost.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=RepetierHost
Icon=RepetierHost
Exec=${dst}
Keywords=slice;3D;printer;convert;gcode;stl;obj;amf;
StartupNotify=false
StartupWMClass=RepetierHost
MimeType=application/sla;model/x-wavefront-obj;model/x-geomview-off;application/x-amf;
Categories=Development;Engineering;
EOF