#!/bin/bash

set -v

# option 1: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt#option-1-install-with-one-command
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

## Download and install the Microsoft signing key
#curl -sL https://packages.microsoft.com/keys/microsoft.asc \
#    | gpg --dearmor \
#    | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
#
## Add the Azure CLI software repository
#AZ_REPO=$(lsb_release -cs)
#echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" \
#    | sudo tee /etc/apt/sources.list.d/azure-cli.list
#
## Update repository information and install the azure-cli package
#sudo apt-get update
#sudo apt-get install --yes azure-cli
#
## Add Azure CLI bash completion
#sudo wget https://raw.githubusercontent.com/Azure/azure-cli/dev/az.completion -O /opt/az/az.completion
