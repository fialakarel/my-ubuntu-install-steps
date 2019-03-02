#!/bin/bash

set -v

# Set correct hostname
oldhostname=$(hostname)
hostnamectl set-hostname think
sed -i "s/$oldhostname/think/g" /etc/hosts

# Fix Intel Backlight control for newer Ubuntu
# Reference https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=833508#20
cat >>/etc/X11/xorg.conf <<EOF
Section "Device"
  Identifier "Intel"
  Driver "intel"
EndSection
EOF
