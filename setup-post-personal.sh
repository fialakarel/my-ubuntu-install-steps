#!/bin/bash 

set -v

bash ~/install/node.sh

cd ~/.dotfiles
git remote remove origin
git remote add origin git@github.com:fialakarel/dotfiles.git

mkdir -p git/github.com
mkdir -p git/gitlab.fialakarel.cz

bash ~/install/pycharm.sh
