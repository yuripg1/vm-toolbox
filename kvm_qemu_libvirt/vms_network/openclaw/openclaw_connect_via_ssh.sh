#!/usr/bin/env bash
set -eu -o pipefail
source ./config.sh

ssh -p 22 ${VM_USERNAME}@${IP_ADDRESS}
