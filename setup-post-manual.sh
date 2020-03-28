#!/bin/bash

set -ve

# There are steps to finish your installation.

# Change your user password
passwd

# Change your hard drive password
# TODO: determine rootfs to change password
sudo cryptsetup luksHeaderBackup /dev/sda5 --header-backup-file /boot/luks-header.backup
sudo cryptsetup luksChangeKey /dev/sda5

# Configure vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
set +e
vim +PluginInstall +qall
set -e

# Please, launch Insync and synchronize data
# Press a key to continue
read dummy

# Entering noninteractive state
export DEBIAN_FRONTEND=noninteractive
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections

# Update
sudo apt-get update

# Fully upgrade first
sudo apt-get -o Dpkg::Options::="--force-confold" dist-upgrade -y

# Install all other packages
sudo apt-get -o Dpkg::Options::="--force-confold" install --yes \
    alsa-utils aspell-cs atool arandr bc bleachbit bridge-utils \
    caca-utils cifs-utils cups debian-goodies deborphan detox \
    docker.io exifprobe feh ffmpeg freerdp2-x11 gimp git gpicview gpicview highlight \
    htop i3 i3status i7z ifenslave imagemagick iperf j4-dmenu-desktop key-mon kvmtool \
    libimage-exiftool-perl libnotify-bin libpango1.0-0 libreoffice-base libreoffice-calc \
    libreoffice-impress libreoffice-l10n-cs libreoffice-writer lptools lxc lxd \
    lxd-client lxd-tools mediainfo mesa-utils mplayer mpv nfs-common nmap ntp ntpdate \
    openvpn pandoc poppler-utils prelink preload pulseaudio pv \
    python3-pip qemu-kvm qemu-system qemu-utils ranger screen screengrab \
    simplescreenrecorder smartmontools sshfs ssvnc terminator tmux tree trickle \
    ttf-mscorefonts-installer udiskie unrar usb-creator-common usb-creator-gtk vim \
    virt-goodies virt-manager vlan w3m wakeonlan wpasupplicant x2goclient xdotool \
    xinit xinput xtightvncviewer xorg zathura unzip parcellite acpi keepass2 \
    suckless-tools curl wget net-tools xbacklight xserver-xorg-video-intel \
    mirage p7zip-full spice-vdagent gir1.2-spiceclientgtk-3.0 jq \
    xclip mosh gparted xutils

# Skipped packages
#texlive-full texlive-bibtex-extra texlive-lang-czechslovak texlive-xetex texmaker
#youtube-dl -> should be install via pip
#wireshark -> I mostly use tcpdump

# Add groups
sudo adduser kfiala lxd
sudo adduser kfiala docker

# Install system wide python packages
sudo pip3 install --upgrade setuptools
sudo pip3 install --upgrade wheel
sudo pip3 install --upgrade ansible
sudo pip3 install --upgrade youtube-dl
sudo pip3 install --upgrade cookiecutter

# Install VS Code
wget "https://go.microsoft.com/fwlink/?LinkID=760868" -O /tmp/vscode.deb
set +e
sudo dpkg -i /tmp/vscode.deb
set -e
sudo apt-get install -fy
rm /tmp/vscode.deb

# Install Miniconda3
wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" -O /tmp/miniconda3.sh
bash /tmp/miniconda3.sh -b -s -p $HOME/miniconda3
rm /tmp/miniconda3.sh

# Get HW serial
serial="$(sudo dmidecode -s baseboard-serial-number)"

# Execute machine specific install steps
if [ -f setup-post-specific-${serial}.sh ]
then
    bash setup-post-specific-${serial}.sh
fi

# Git clone install scripts for further use
git clone https://github.com/fialakarel/my-ubuntu-install-steps ~/.my-ubuntu-install-steps

# Installation finished ...
# Please, reboot the system to take effect.
