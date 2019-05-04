#!/bin/bash

# post install for T480 for work

set -v

bash ~/install/azure-cli.sh
bash ~/install/helm.sh
bash ~/install/kubectl.sh
bash ~/install/terraform.sh