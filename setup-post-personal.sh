#!/bin/bash 

set -v

cd ~/.dotfiles
git remote remove origin
git remote add origin git@github.com:fialakarel/dotfiles.git

mkdir -p git/github.com
mkdir -p git/gitlab.fialakarel.cz
