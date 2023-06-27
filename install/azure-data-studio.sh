#!/bin/bash

set -v

# Install Azure Data Studio
# https://learn.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio
wget "https://go.microsoft.com/fwlink/?linkid=2237414" -O /tmp/azure-data-studio.deb
set +e
sudo apt install /tmp/azure-data-studio.deb
set -e
sudo apt-get install -fy
rm /tmp/azure-data-studio.deb