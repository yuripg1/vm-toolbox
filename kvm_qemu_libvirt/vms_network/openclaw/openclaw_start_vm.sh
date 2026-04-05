#!/usr/bin/env bash
set -eu -o pipefail
source ./config.sh

virsh start ${PROJECT_NAME}
