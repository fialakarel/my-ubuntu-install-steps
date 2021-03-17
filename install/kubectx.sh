#!/bin/bash

set -v

user="$(id --user --name)"
dst_kubectx="/home/${user}/bin/kubectx"
dst_kubens="/home/${user}/bin/kubens"

# Create dir for bin files
mkdir $HOME/bin

# Get latest version
version="$(curl https://github.com/ahmetb/kubectx/releases/latest | cut -d'"' -f2 | egrep -o "[0-9]+\.[0-9]+\.[0-9]+$")"

base_url="https://github.com/ahmetb/kubectx/releases/download/v${version}"

# Download kubectx and kubens
wget $base_url/kubectx -O $dst_kubectx
wget $base_url/kubens -O $dst_kubens

# Set permissions
chmod +x $dst_kubectx
chmod +x $dst_kubens