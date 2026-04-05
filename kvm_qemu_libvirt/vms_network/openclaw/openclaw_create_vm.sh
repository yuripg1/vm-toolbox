#!/usr/bin/env bash
set -eu -o pipefail
source ./config.sh

DISK_NAME="${PROJECT_NAME}.qcow2"
PROJECT_IMAGES_PATH="${LIBVIRT_IMAGES_PATH}/${PROJECT_NAME}"
INITIAL_DISK_PATH="./${DISK_NAME}"
INITIAL_ISO_PATH="./${ISO_NAME}"
ISO_PATH="${PROJECT_IMAGES_PATH}/${ISO_NAME}"
OWNERSHIP="libvirt-qemu:kvm"
VM_DISK="path=\"${PROJECT_IMAGES_PATH}/${DISK_NAME}\",format=qcow2"
VM_NETWORK="network=${NETWORK_NAME},model=virtio,mac=${MAC_ADDRESS}"
VM_GRAPHICS="vnc"

# Adds a static DHCP lease for the MAC address of the VM
virsh net-update ${NETWORK_NAME} add ip-dhcp-host "<host mac=\"${MAC_ADDRESS}\" ip=\"${IP_ADDRESS}\"/>" --live --config

# Creates the disk
qemu-img create -f qcow2 ${INITIAL_DISK_PATH} ${DISK_SIZE}

# Moves the disk and the installation media
sudo mkdir -p ${PROJECT_IMAGES_PATH}
sudo mv ${INITIAL_DISK_PATH} ${PROJECT_IMAGES_PATH}
sudo mv ${INITIAL_ISO_PATH} ${PROJECT_IMAGES_PATH}
sudo chown -R ${OWNERSHIP} ${PROJECT_IMAGES_PATH}

# Creates the VM
virt-install --name ${PROJECT_NAME} --cdrom ${ISO_PATH} --memory ${VM_MEMORY_MB} --vcpus ${VM_VCPUS} --disk ${VM_DISK} --os-variant ${VM_OS_VARIANT} --network ${VM_NETWORK} --graphics ${VM_GRAPHICS}
