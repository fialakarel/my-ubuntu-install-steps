#!/bin/bash

# post install for T480 for work

set -v

bash ~/install/azure-cli.sh
bash ~/install/helm.sh
bash ~/install/kubectl.sh
bash ~/install/terraform.sh
bash ~/install/lenovo-throttling-fix.sh
bash ~/install/tlp.sh
bash ~/install/update-firmware.sh
