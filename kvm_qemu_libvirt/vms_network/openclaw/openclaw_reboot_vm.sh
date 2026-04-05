#!/usr/bin/env bash
set -eu -o pipefail
source ./config.sh

virsh reboot ${PROJECT_NAME}
