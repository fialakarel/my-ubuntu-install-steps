#!/bin/bash

set -v

# Install VS Code
wget "https://go.microsoft.com/fwlink/?LinkID=760868" -O /tmp/vscode.deb
set +e
sudo dpkg -i /tmp/vscode.deb
set -e
sudo apt-get install -fy
rm /tmp/vscode.deb