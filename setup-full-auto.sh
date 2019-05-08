#!/bin/bash

set -v

export DEBIAN_FRONTEND=noninteractive

# Update
apt-get update

# Install base packages
apt-get install --yes htop tmux screen vim git bash-completion software-properties-common

# Kernel tweaks
cat >>/etc/sysctl.conf <<EOF

# inotify tweaks
fs.inotify.max_user_watches = 1048576
fs.inotify.max_user_instances = 256

# allow sysrq
kernel.sysrq = 1
EOF

# Set eth0 interface to managed -> Do not use on the servers
cat >/etc/network/interfaces <<EOF
auto lo
iface lo inet loopback
EOF

# Add Nextcloud repo
add-apt-repository --yes ppa:nextcloud-devs/client

apt-get update

# Install necessary packages for the first boot
apt-get install --yes alsa-utils atool arandr bc chromium-browser \
    cifs-utils cups debian-goodies detox feh i3 i3status i7z curl wget \
    j4-dmenu-desktop libimage-exiftool-perl libnotify-bin libpango1.0-0 \
    mesa-utils mplayer nfs-common ntp openvpn nextcloud-client prelink preload \
    pulseaudio pv python3-pip ranger screen dnsutils \
    smartmontools terminator tmux tree udiskie unrar vim w3m wpasupplicant \
    xdotool xinit xinput xorg zathura unzip acpi keepass2 suckless-tools \
    net-tools xbacklight xserver-xorg-video-intel upower \
    xserver-xorg-input-all xserver-xorg-input-libinput xserver-xorg-input-synaptics \
    openvpn-systemd-resolved zip i3lock git-lfs dosfstools scrot

# Fix apps
mkdir -p /home/kfiala/.local/share
chown -R kfiala:kfiala /home/kfiala
ln -s /usr/share/applications/ /home/kfiala/.local/share/applications

# Fix file types

# Reinstall mime
apt-get install --reinstall --yes shared-mime-info

# Update mime
update-mime-database /usr/share/mime

# Link to local
ln -s /usr/share/mime /home/kfiala/.local/share/mime

# Handle power button
echo "HandlePowerKey=suspend" >>/etc/systemd/logind.conf
echo "HandleLidSwitch=ignore" >>/etc/systemd/logind.conf
echo "LidSwitchIgnoreInhibited=yes" >>/etc/systemd/logind.conf

# Fix keyboard layout
sed -i 's/XKBLAYOUT="us"/XKBLAYOUT="cz"/' /etc/default/keyboard
dpkg-reconfigure keyboard-configuration

# Fix locales
locale-gen en_US.UTF-8
update-locale LANG="en_US.UTF-8"
echo "LANG=en_US.UTF-8" >/etc/default/locale

# Fix DNS
echo "Cache=no" >>/etc/systemd/resolved.conf

# Template for WiFi configuration
cat >/etc/wpa_supplicant/config.conf <<EOF
ctrl_interface=/run/wpa_supplicant
update_config=1

#network={
#	ssid="editthiswpa2wifi"
#	psk="securepassword"
#}

#network={
#	ssid="freewifi"
#	key_mgmt=NONE
#}
EOF

# Get HW serial
serial="$(dmidecode -s baseboard-serial-number)"

# Execute machine specific install steps
bash setup-specific-${serial}.sh

# Get my configuration
runuser -l kfiala -c 'git clone https://github.com/fialakarel/dotfiles .dotfiles'
runuser -l kfiala -c 'bash .dotfiles/delete-local-config.sh'
runuser -l kfiala -c 'bash .dotfiles/create-symlinks.sh'

# Minor tweak -- remove sudo message before first use
runuser -l kfiala -c 'touch .sudo_as_admin_successful'
runuser -l kfiala -c 'mkdir temp'

# Fix Keepass2 segfault on Ubuntu
sed -i "s/cli/cli --verify-all/" $(which keepass2)
