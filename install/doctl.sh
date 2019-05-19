#!/bin/bash

set -v

version="1.17.0"

cd /tmp

wget https://github.com/digitalocean/doctl/releases/download/v${version}/doctl-${version}-linux-amd64.tar.gz -O doctl.tgz

tar xf doctl.tgz

mv doctl $HOME/bin/.

chmod +x $HOME/bin/doctl

rm doctl.tgz
