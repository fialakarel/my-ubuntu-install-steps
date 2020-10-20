#!/bin/bash

set -v

# Create bin folder
if [ ! -d $HOME/bin ]
then
  mkdir $HOME/bin
fi

version="$(curl https://github.com/hashicorp/terraform/releases/latest | cut -d'"' -f2 | egrep -o "[0-9]+\.[0-9]+\.[0-9]+$")"

# Get terraform
wget https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_amd64.zip -O /tmp/terraform.zip

# Extract Terraform binary
unzip -p /tmp/terraform.zip terraform >$HOME/bin/terraform

# Fix permissions
chmod +x $HOME/bin/terraform

# Cleaning
rm /tmp/terraform.zip
