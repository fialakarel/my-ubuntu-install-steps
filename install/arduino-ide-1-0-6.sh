#!/bin/bash

set -v

cd /opt

dir="arduino-1.0.6"
dirtar="${dir}-linux64.tgz"

sudo wget https://downloads.arduino.cc/${dirtar}

sudo tar -xzf $dirtar

sudo rm $dirtar

ln -s /opt/${dir}/arduino /home/$(id --user --name)/bin/arduino

# Writing desktop file
cat <<EOF | sudo tee /usr/share/applications/Arduino-IDE.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Arduino IDE
Icon=Arduino IDE
Exec=/opt/${dir}/arduino
Keywords=arduino;ide;ino;
StartupNotify=false
StartupWMClass=ArduinoIDE
Categories=Development;Engineering;
EOF