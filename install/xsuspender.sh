#!/bin/bash

set -ve

sudo apt update
sudo apt install libglib2.0-dev \
                 libwnck-3-dev  \
                 procps         \
                 make cmake gcc pkg-config

cd /tmp

# Fetch a copy of the source code
git clone https://github.com/kernc/xsuspender
cd xsuspender

# Move to build directory for an out-of-tree build
cd build

# Configure and make
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
make
make test

# Install within chosen prefix
sudo make install

cd /tmp
rm -rf xsuspender
