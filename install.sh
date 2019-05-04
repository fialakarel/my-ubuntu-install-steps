#!/bin/bash

set -v

# Process required steps in auto mode
# There should be everything which has to be done before first login
bash setup-full-auto.sh

# Prepare last manual steps
# There should be everything which takes long time
cp setup-post-* /home/kfiala/.
cp -r install /home/kfiala/.