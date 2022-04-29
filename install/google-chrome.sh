#!/bin/bash

set -v

cd /tmp

# Get chrome
curl "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -o "chrome.deb"

# Install
sudo apt install ./chrome.deb -fy

# Cleaning
rm -r ./chrome.deb