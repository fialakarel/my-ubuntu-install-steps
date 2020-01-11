#!/bin/bash

set -v

sudo add-apt-repository --yes ppa:linuxuprising/apps

sudo apt update

sudo apt install --yes tlp tlpui
