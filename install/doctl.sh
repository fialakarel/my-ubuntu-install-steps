#!/bin/bash

set -v

version="$(curl https://github.com/digitalocean/doctl/releases/latest | cut -d'"' -f2 | egrep -o "[0-9]+\.[0-9]+\.[0-9]+$")"

cd /tmp

wget https://github.com/digitalocean/doctl/releases/download/v${version}/doctl-${version}-linux-amd64.tar.gz -O doctl.tgz


tar xf doctl.tgz

mv doctl $HOME/bin/.

chmod +x $HOME/bin/doctl

rm doctl.tgz
