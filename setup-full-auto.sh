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
apt-get install --yes alsa-utils atool arandr bc bridge-utils chromium-browser \
    cifs-utils cups debian-goodies detox docker.io exifprobe feh ffmpeg \
    freerdp-x11 git i3 i3status i7z ifenslave imagemagick iperf \
    j4-dmenu-desktop libimage-exiftool-perl libnotify-bin libpango1.0-0 \
    lxc lxd lxd-client lxd-tools mediainfo mesa-utils mplayer nfs-common \
    nmap ntp ntpdate openvpn nextcloud-client prelink preload pulseaudio pv \
    python3-pip qemu-kvm qemu-system qemu-utils ranger screen screengrab \
    simplescreenrecorder smartmontools sshfs ssvnc terminator tmux tree \
    ttf-mscorefonts-installer udiskie unrar vim virt-goodies virt-manager \
    vlan w3m wakeonlan wpasupplicant xdotool xinit xinput xtightvncviewer \
    xorg zathura unzip acpi keepass2 suckless-tools curl wget net-tools \
    xbacklight xserver-xorg-video-intel upower xserver-xorg-input-synaptics

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

# Fix DNS
echo "Cache=no" >>/etc/systemd/resolved.conf

# Add groups
adduser kfiala lxd
adduser kfiala docker

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
