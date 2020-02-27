#!/bin/bash

set -v

# Install prerequisites
sudo apt update
sudo apt-get install --yes ruby-full build-essential zlib1g-dev

# Install jekyll
sudo gem install jekyll bundler
