#!/bin/bash

set -v

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C

source /etc/os-release

CODENAME="${VERSION_CODENAME}"

# override for now
CODENAME="impish"

echo "deb http://apt.insync.io/ubuntu ${CODENAME} non-free contrib" | sudo tee /etc/apt/sources.list.d/insync.list

sudo apt-get update
sudo apt-get install -fy insync
