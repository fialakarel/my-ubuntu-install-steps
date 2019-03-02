#!/bin/bash

set -v

# Set correct hostname
oldhostname=$(hostname)
hostnamectl set-hostname beta
sed -i "s/$oldhostname/beta/g" /etc/hosts
