#!/bin/bash

set -v

# Documentation
# https://docs.microsoft.com/en-us/azure/storage/common/storage-ref-azcopy-sync
# https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10

cd /tmp

# Get azcopy
curl -L "https://aka.ms/downloadazcopy-v10-linux" --output azcopy_linux_amd64.tar.gz

# Untar
tar -xzf azcopy_linux_amd64.tar.gz

# Install
cd azcopy_linux_amd64_*
mkdir ~/bin
mv azcopy ~/bin/.

# Cleaning
cd /tmp
rm -rf azcopy_*
