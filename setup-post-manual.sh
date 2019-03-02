#!/bin/bash

set -v

# There are steps to finish your installation.

# Change your user password
passwd

# Change your hard drive password
sudo cryptsetup luksHeaderBackup /dev/sda5 --header-backup-file /root/luks-header.backup
sudo cryptsetup luksChangeKey /dev/sda5

# Please, launch Nextcloud and synchronize data
# Press a key to continue
read dummy

# Entering noninteractive state
export DEBIAN_FRONTEND=noninteractive

# Update
sudo apt-get update

# Install all other packages
sudo apt-get install --yes alsa-utils aspell-cs atool arandr bc bleachbit bridge-utils \
    caca-utils chromium-browser cifs-utils criu cups debian-goodies deborphan detox \
    docker.io exifprobe feh ffmpeg freerdp-x11 gimp git gpicview gpicview-dbg highlight \
    htop i3 i3status i7z ifenslave imagemagick iperf j4-dmenu-desktop key-mon kvmtool \
    libimage-exiftool-perl libnotify-bin libpango1.0-0 libreoffice-base libreoffice-calc \
    libreoffice-impress libreoffice-l10n-cs libreoffice-writer lptools lxc lxd \
    lxd-client lxd-tools mediainfo mesa-utils mplayer mpv nfs-common nmap ntp ntpdate \
    openvpn nextcloud-client pandoc poppler-utils prelink preload pulseaudio pv \
    python3-pip qemu-kvm qemu-system qemu-utils ranger screen screengrab \
    simplescreenrecorder smartmontools sshfs ssvnc terminator tmux tree trickle \
    ttf-mscorefonts-installer udiskie unrar usb-creator-common usb-creator-gtk vim \
    virt-goodies virt-manager vlan w3m wakeonlan wpasupplicant x2goclient xdotool \
    xinit xinput xtightvncviewer xorg zathura unzip parcellite acpi keepass2 \
    suckless-tools curl wget net-tools xbacklight xserver-xorg-video-intel

# Fully upgrade
sudo apt-get dist-upgrade -y

# Skipped packages
#texlive-full texlive-bibtex-extra texlive-lang-czechslovak texlive-xetex texmaker
#youtube-dl -> should be install via pip
#wireshark -> I mostly use tcpdump

# Add groups
sudo adduser kfiala lxd
sudo adduser kfiala docker

# Install VS Code
wget "https://go.microsoft.com/fwlink/?LinkID=760868" -O /tmp/vscode.deb
sudo dpkg -i /tmp/vscode.deb
sudo apt-get install -fy
rm /tmp/vscode.deb
