# Configure or check the values below
PROJECT_NAME="openclaw-vm"
NETWORK_NAME="vms"
MAC_ADDRESS="52:54:00:d0:eb:11"
IP_ADDRESS="192.168.169.253"
VM_MEMORY_MB="4096"
VM_VCPUS="2"
DISK_SIZE="40G"
BASE_PATH="."
ISO_NAME="ubuntu-24.04.4-live-server-amd64.iso"
VM_OS_VARIANT="ubuntu24.04"
# Configure or check the values above

DISK_NAME="${PROJECT_NAME}.qcow2"
IMAGES_PATH="/var/lib/libvirt/images/${PROJECT_NAME}"
INITIAL_DISK_PATH="${BASE_PATH}/${DISK_NAME}"
INITIAL_ISO_PATH="${BASE_PATH}/${ISO_NAME}"
DISK_PATH="${IMAGES_PATH}/${DISK_NAME}"
ISO_PATH="${IMAGES_PATH}/${ISO_NAME}"
OWNERSHIP="libvirt-qemu:kvm"
VM_DISK="path=\"${DISK_PATH}\",format=qcow2"
VM_NETWORK="network=${NETWORK_NAME},model=virtio,mac=${MAC_ADDRESS}"
VM_GRAPHICS="vnc"

# Adds a static DHCP lease for the MAC address of the VM
virsh net-update ${NETWORK_NAME} add ip-dhcp-host "<host mac=\"${MAC_ADDRESS}\" ip=\"${IP_ADDRESS}\"/>" --live --config

# Creates the disk
qemu-img create -f qcow2 ${INITIAL_DISK_PATH} ${DISK_SIZE}

# Moves the disk and the installation media
sudo mkdir -p ${IMAGES_PATH}
sudo mv ${INITIAL_DISK_PATH} ${IMAGES_PATH}
sudo mv ${INITIAL_ISO_PATH} ${IMAGES_PATH}
sudo chown -R ${OWNERSHIP} ${IMAGES_PATH}

# Creates the VM
virt-install --name ${PROJECT_NAME} --cdrom ${ISO_PATH} --memory ${VM_MEMORY_MB} --vcpus ${VM_VCPUS} --disk ${VM_DISK} --os-variant ${VM_OS_VARIANT} --network ${VM_NETWORK} --graphics ${VM_GRAPHICS}
