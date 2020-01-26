#!/bin/bash

set -v

# Set correct hostname
oldhostname=$(hostname)
hostnamectl set-hostname beta
sed -i "s/$oldhostname/beta/g" /etc/hosts

# Fix NUC sound noise
echo "options snd-hda-intel power_save=0 power_save_controller=N" >/etc/modprobe.d/alsa-base.conf
