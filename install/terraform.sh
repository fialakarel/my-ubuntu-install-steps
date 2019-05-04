#!/bin/bash

set -v

# Create bin folder
if [ ! -d $HOME/bin ]
then
  mkdir $HOME/bin
fi

# Get terraform
wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip -O /tmp/terraform.zip

# Extract Terraform binary
unzip -p /tmp/terraform.zip terraform >$HOME/bin/terraform

# Fix permissions
chmod +x $HOME/bin/terraform

# Cleaning
rm /tmp/terraform.zip
