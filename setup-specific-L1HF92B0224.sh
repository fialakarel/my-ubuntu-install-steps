#!/bin/bash

# T480 for work

set -v

# Set correct hostname
oldhostname=$(hostname)
newhostname="d8m"
hostnamectl set-hostname $newhostname
sed -i "s/$oldhostname/$newhostname/g" /etc/hosts

# Fix Intel Backlight control for newer Ubuntu
# Reference https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=833508#20
cat >>/etc/X11/xorg.conf <<EOF
Section "Device"
  Identifier "Intel"
  Driver "intel"
EndSection
EOF
