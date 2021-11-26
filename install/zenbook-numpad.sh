#!/bin/bash

set -veufo pipefail

sudo apt update
sudo apt install --yes libevdev2 python3-libevdev i2c-tools git

sudo modprobe i2c-dev

sudo i2cdetect -l

cd /tmp

git clone https://github.com/mohamed-badaoui/asus-touchpad-numpad-driver

cd asus-touchpad-numpad-driver

chmod +x install.sh

sudo ./install.sh

cd /tmp
rm -rf asus-touchpad-numpad-driver
