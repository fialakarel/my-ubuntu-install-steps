#!/bin/bash

set -v

# stopped working -- github is blocking non-browser downloads
#version="$(curl https://github.com/digitalocean/doctl/releases/latest | cut -d'"' -f2 | egrep -o "[0-9]+\.[0-9]+\.[0-9]+$")"
version="1.84.1"

cd /tmp

wget --no-verbose https://github.com/digitalocean/doctl/releases/download/v${version}/doctl-${version}-linux-amd64.tar.gz -O doctl.tgz

tar xf doctl.tgz

mv doctl $HOME/bin/.

chmod +x $HOME/bin/doctl

rm doctl.tgz