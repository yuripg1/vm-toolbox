#!/usr/bin/env bash
set -eu -o pipefail
source ./config.sh

ssh -N -L 18789:127.0.0.1:18789 -p 22 ${VM_USERNAME}@${IP_ADDRESS}
