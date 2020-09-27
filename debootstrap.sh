#!/bin/bash

set -veufo pipefail

# ##### ##### ##### ##### ##### ##### ##### ##### #####
# This script will debootstrap a fresh OS installation.
# 
# You just need to boot the live debian based OS
# eg. https://clonezilla.org/downloads.php
# and configure the network.
# #> ip link set eth0 up
# #> dhclient eth0
#
# In case you would like to start SSH Daemon run
# #> /etc/init.d/ssh start
#
# and do not forget to load your pub keys.
# #> mkdir .ssh
# #> curl https://github.com/fialakarel.keys >.ssh/authorized_keys
# 
# To execute this script, simply run
# #> curl https://raw.githubusercontent.com/fialakarel/my-ubuntu-install-steps/master/debootstrap.sh | sudo bash
# ##### ##### ##### ##### ##### ##### ##### ##### #####

# Variables
RELEASE="focal"
DISK="/dev/vda" # Probably, you will need to adjust this to fit your needs.
PART="${DISK}1"
TARGET="/mnt/target"
FS="ext4"
USER="kfiala"

# Make sure we have debootstrap installed
apt-get update
apt-get install --yes binutils debootstrap

# Create a partion
(
echo o # Create a new empty DOS partition table
echo n # Add a new partition
echo p # Primary partition
echo 1 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo a # Set boot flag
echo w # Write changes
) | fdisk ${DISK}

# Create a FS
mkfs.${FS} ${PART}

# Mount it
mkdir ${TARGET}
mount ${PART} ${TARGET}

# Debootstrap minimal system
debootstrap --arch amd64 ${RELEASE} ${TARGET} http://archive.ubuntu.com/ubuntu

# Mounts
mount -t proc proc ${TARGET}/proc
mount -t sysfs sys ${TARGET}/sys
mount -o bind /tmp ${TARGET}/tmp
mount -o bind /dev ${TARGET}/dev
mount -t devpts none ${TARGET}/dev/pts

# Create /etc/fstab
echo "UUID=$(blkid | grep "${PART}" | cut -d' ' -f2 | cut -d'"' -f2) / ${FS} defaults,noatime,errors=remount-ro 0 1" >${TARGET}/etc/fstab

# Fix apt sources
cat <<EOF >${TARGET}/etc/apt/sources.list
deb http://cz.archive.ubuntu.com/ubuntu/ ${RELEASE} main restricted
deb http://cz.archive.ubuntu.com/ubuntu/ ${RELEASE}-updates main restricted
deb http://cz.archive.ubuntu.com/ubuntu/ ${RELEASE} universe
deb http://cz.archive.ubuntu.com/ubuntu/ ${RELEASE}-updates universe
deb http://cz.archive.ubuntu.com/ubuntu/ ${RELEASE} multiverse
deb http://cz.archive.ubuntu.com/ubuntu/ ${RELEASE}-updates multiverse
deb http://cz.archive.ubuntu.com/ubuntu/ ${RELEASE}-backports main restricted universe multiverse
deb http://archive.canonical.com/ubuntu ${RELEASE} partner
deb-src http://archive.canonical.com/ubuntu ${RELEASE} partner
deb http://security.ubuntu.com/ubuntu ${RELEASE}-security main restricted
deb http://security.ubuntu.com/ubuntu ${RELEASE}-security universe
deb http://security.ubuntu.com/ubuntu ${RELEASE}-security multiverse
EOF

# Fix locales issue
export LANG=C.UTF-8

# Run this inside the chroot
cat <<EOF | chroot ${TARGET}
# Install some packages
apt update
apt install --yes linux-image-generic grub2 lvm2 ifupdown net-tools curl wget ubuntu-server git

# Get rid of playmount
apt purge --yes plymouth-theme-ubuntu-text

# Fix locales
locale-gen en_US.UTF-8

# Add user
addgroup --system ${USER}
useradd -s /bin/bash -g ${USER} -m -k /dev/null ${USER}
echo "${USER}:ubuntu" | chpasswd

# Fix sudoers
sed -i "s/ALL$/NOPASSWD:ALL/" /etc/sudoers

# Add groups to newly created user
usermod -aG adm ${USER}
usermod -aG cdrom ${USER}
usermod -aG sudo ${USER}
usermod -aG dip ${USER}
usermod -aG plugdev ${USER}
#usermod -aG lpadmin ${USER}
#usermod -aG sambashare ${USER}

# Configure grub
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=".*"/GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0 biosdevname=0"/' /etc/default/grub
echo 'GRUB_DISABLE_OS_PROBER="true"' >> /etc/default/grub
grub-install --boot-directory=/boot ${DISK}
update-grub
EOF


# First boot bootstrap
cat <<EOF >${TARGET}/etc/rc.local
#!/bin/bash

# wait for full system startup
sleep 5

# fix terminal setup
export TERM=xterm

# run each /etc/setup-*
for script in \$(ls -1 /etc/setup-*)
do
	# permissions
	chmod +x \$script

	# execute 
	openvt -s -w \$script

	# cleaning
	rm \$script
done

# delete this file
>/etc/rc.local

# restart to take effects
reboot
EOF
chmod +x ${TARGET}/etc/rc.local

# Script running during the first boot
cat <<EOD >${TARGET}/etc/setup-10-base.sh
#!/bin/bash

set -v

## ## ## ## ## ## ## ## ## ## ## ## ## ##
##                                     ##
## First startup setup in progres ...  ##
##                                     ##
## ## ## ## ## ## ## ## ## ## ## ## ## ##

# Get IP
# Template for netplan
cat >/etc/netplan/01-netcfg.yaml <<EOF
# This file describes the network interfaces available on your system
# For more information, see netplan(5).
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: yes
EOF

# Activate networking
netplan apply

# Wait for a network
sleep 5

# Trim FS
fstrim --verbose --all

# Get my latest install steps
git clone https://github.com/fialakarel/my-ubuntu-install-steps /tmp/my-ubuntu-install-steps

# Execute install steps
cd /tmp/my-ubuntu-install-steps
bash install.sh

# Cleaning
rm -rf /tmp/my-ubuntu-install-steps
EOD

# Reboot the system
reboot
