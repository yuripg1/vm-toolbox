#!/usr/bin/env bash
set -eu -o pipefail
source ./config.sh

PROJECT_IMAGES_PATH="${LIBVIRT_IMAGES_PATH}/${PROJECT_NAME}"
DEFAULT_USER_GROUP=$(id -gn)

# Moves back the installation media to the working directory
sudo mv ${PROJECT_IMAGES_PATH}/${ISO_NAME} .
sudo chown ${USER}:${DEFAULT_USER_GROUP} ./${ISO_NAME}

# Deletes the VM and its known storage resources
virsh undefine ${PROJECT_NAME} --remove-all-storage

# Removes any remaining resources of the VM
sudo rm -rf ${PROJECT_IMAGES_PATH}

# Removes the static DHCP lease for the MAC address of the VM
virsh net-update ${NETWORK_NAME} delete ip-dhcp-host "<host mac=\"${MAC_ADDRESS}\" ip=\"${IP_ADDRESS}\"/>" --live --config

# Removes entry in the known_hosts file (if there is one)
ssh-keygen -R ${IP_ADDRESS} || true
