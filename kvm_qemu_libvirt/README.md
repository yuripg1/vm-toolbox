# KVM + QEMU + libvirt

Run the commands below:

```shell
$ sudo apt update
$ sudo apt -y install cpu-checker
$ kvm-ok
$ sudo apt -y install bridge-utils libvirt-daemon-system qemu-kvm virt-manager virt-viewer
$ sudo usermod -aG kvm,libvirt $USER
```

After that, log out and log back in for the new group memberships to take effect.
