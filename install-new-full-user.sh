#!/bin/bash

set -ve

export DEBIAN_FRONTEND=noninteractive

# Fix sudoers
sudo sed -i "s/ALL$/NOPASSWD:ALL/" /etc/sudoers

# Fix grub
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=".*"/GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0 biosdevname=0"/' /etc/default/grub
echo 'GRUB_DISABLE_OS_PROBER="true"' | sudo tee -a /etc/default/grub
sudo update-grub

# Update
sudo apt-get update

# Install base packages
sudo apt-get install --yes htop tmux screen vim git bash-completion software-properties-common wget gpg-agent dirmngr

# Kernel tweaks
cat | sudo tee -a /etc/sysctl.conf <<EOF

# inotify tweaks
fs.inotify.max_user_watches = 1048576
fs.inotify.max_user_instances = 256

# allow sysrq
kernel.sysrq = 1
EOF

# Add Chrome repo
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

# Get Insync pubkey and add the Insync software repository
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys ACCAF35C
export DISTRO=$(lsb_release -cs)
echo "deb http://apt.insync.io/ubuntu $DISTRO non-free contrib" | sudo tee /etc/apt/sources.list.d/insync.list

sudo apt-get update

# Install necessary packages for the first boot
sudo apt-get install --yes alsa-utils atool arandr bc google-chrome-stable \
    cifs-utils cups debian-goodies detox feh i3 i3status i7z curl wget \
    j4-dmenu-desktop libimage-exiftool-perl libnotify-bin libpango1.0-0 \
    mesa-utils mplayer nfs-common ntp openvpn prelink preload \
    pulseaudio pv python3-pip ranger screen dnsutils \
    smartmontools terminator tmux tree udiskie unrar vim w3m wpasupplicant \
    xdotool xinit xinput xorg zathura unzip acpi keepass2 suckless-tools \
    net-tools xbacklight xserver-xorg-video-intel upower \
    xserver-xorg-input-all xserver-xorg-input-libinput xserver-xorg-input-synaptics \
    openvpn-systemd-resolved zip i3lock git-lfs dosfstools scrot exfat-utils exfat-fuse \
    gnome-keyring pavucontrol pasystray insync git-crypt xclip

# Handle power button
echo "HandlePowerKey=suspend" | sudo tee -a /etc/systemd/logind.conf
echo "HandleLidSwitch=ignore" | sudo tee -a /etc/systemd/logind.conf
echo "LidSwitchIgnoreInhibited=yes" | sudo tee -a /etc/systemd/logind.conf

## Fix keyboard layout
#sudo sed -i 's/XKBLAYOUT="us"/XKBLAYOUT="cz"/' /etc/default/keyboard
#sudo dpkg-reconfigure keyboard-configuration

## Fix locales
#sudo locale-gen en_US.UTF-8
#sudo update-locale LANG="en_US.UTF-8"
#echo "LANG=en_US.UTF-8" | sudo tee /etc/default/locale

## Fix DNS
#echo "Cache=no" | sudo tee -a /etc/systemd/resolved.conf

# Template for netplan
cat | sudo tee /etc/netplan/01-netcfg.yaml <<EOF
# This file describes the network interfaces available on your system
# For more information, see netplan(5).
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: no
  wifis:
    wlan0:
      dhcp4: no
      access-points:
#        "wifi-ssid":
#          password: "wifi-pass"
#        "<SSID>": {}
  bonds:
    bond0:
      dhcp4: yes
      interfaces:
        - eth0
        - wlan0
      parameters:
        mode: active-backup
        primary: eth0
        mii-monitor-interval: 1
        gratuitious-arp: 5
        fail-over-mac-policy: active
EOF

# Lock screen on suspend
cat | sudo tee /etc/systemd/system/lock.service <<EOF
[Unit]
Description=Lock the screen on resume from suspend

[Service]
User=kfiala
Type=forking
Environment=DISPLAY=:0
ExecStart=/usr/bin/i3lock -c 000050

[Install]
WantedBy=suspend.target sleep.target
EOF

# Enable lock.service
sudo systemctl enable lock.service

# Get my configuration
git clone https://github.com/fialakarel/dotfiles ~/.dotfiles
bash ~/.dotfiles/delete-local-config.sh
bash ~/.dotfiles/create-symlinks.sh

mkdir ~/temp
mkdir ~/Downloads
mkdir -p ~/git/github.com
mkdir -p ~/git/gitlab.com

# Fix Keepass2 segfault on Ubuntu
sudo sed -i "s/cli/cli --verify-all/" $(which keepass2)

# Configure vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
set +e
vim +PluginInstall +qall
set -e

# Entering noninteractive state
export DEBIAN_FRONTEND=noninteractive
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections

# Update
sudo apt-get update

# Fully upgrade first
sudo apt-get -o Dpkg::Options::="--force-confold" dist-upgrade --yes

# Install all other packages
sudo apt-get -o Dpkg::Options::="--force-confold" install --yes \
    alsa-utils aspell-cs atool arandr bc bleachbit bridge-utils \
    caca-utils cifs-utils cups debian-goodies deborphan detox \
    docker.io exifprobe feh ffmpeg freerdp2-x11 gimp git gpicview gpicview highlight \
    htop i3 i3status i7z ifenslave imagemagick iperf j4-dmenu-desktop kvmtool \
    libimage-exiftool-perl libnotify-bin libpango1.0-0 libreoffice-base libreoffice-calc \
    libreoffice-impress libreoffice-l10n-cs libreoffice-writer lptools lxc lxd \
    lxd-client lxd-tools mediainfo mesa-utils mplayer mpv nfs-common nmap ntp ntpdate \
    openvpn pandoc poppler-utils prelink preload pulseaudio pv \
    python3-pip qemu-kvm qemu-system qemu-utils ranger screen screengrab \
    simplescreenrecorder smartmontools sshfs ssvnc terminator tmux tree trickle \
    ttf-mscorefonts-installer udiskie unrar usb-creator-common usb-creator-gtk vim \
    virt-manager vlan w3m wakeonlan wpasupplicant x2goclient xdotool \
    xinit xinput xtightvncviewer xorg zathura unzip parcellite acpi keepass2 \
    suckless-tools curl wget net-tools xbacklight xserver-xorg-video-intel \
    p7zip-full spice-vdagent gir1.2-spiceclientgtk-3.0 jq \
    xclip mosh gparted xutils virt-viewer xsel xautolock autofs \
    audacity gparted ntfs-3g gddrescue ssh-askpass ssh-askpass-gnome

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
sudo pip3 install --upgrade autorandr
sudo pip3 install --upgrade ulozto-downloader

# Install VS Code
wget "https://go.microsoft.com/fwlink/?LinkID=760868" -O /tmp/vscode.deb
set +e
sudo dpkg -i /tmp/vscode.deb
set -e
sudo apt-get install -fy
rm /tmp/vscode.deb

# Install my packages
bash ./install/aws-cli.sh
bash ./install/azcopy.sh
bash ./install/azure-cli.sh
bash ./install/doctl.sh
bash ./install/helm.sh
bash ./install/k8s-lens.sh
bash ./install/kubectl.sh
bash ./install/kubectx.sh
bash ./install/node.sh
bash ./install/pyenv-poetry.sh
bash ./install/update-firmware.sh

# Fix dotfiles URL for personal laptop
cd ~/.dotfiles
git remote remove origin
git remote add origin git@github.com:fialakarel/dotfiles.git

# Autofs
sudo mkdir /mnt/s1
echo "/mnt/s1       192.168.1.100:/storage" | sudo tee /etc/auto.nfs
echo "/-            /etc/auto.nfs   --timeout=30" | sudo tee -a /etc/auto.master

# Fix Intel Backlight control for newer Ubuntu
# Reference https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=833508#20
cat | sudo tee -a /etc/X11/xorg.conf <<EOF
Section "Device"
  Identifier "Intel"
  Driver "intel"
EndSection
EOF

# Fix cursor size
echo "Xcursor.size: 16" >~/.Xresources
gsettings set org.gnome.desktop.interface cursor-size 32
xrdb ~/.Xresources

# sensors
sudo apt install --yes lm-sensors
sudo sensors-detect --auto

