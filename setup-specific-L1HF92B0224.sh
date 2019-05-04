#!/bin/bash

# T480 for work

set -v

# Set correct hostname
oldhostname=$(hostname)
newhostname="d8m"
hostnamectl set-hostname $newhostname
sed -i "s/$oldhostname/$newhostname/g" /etc/hosts
