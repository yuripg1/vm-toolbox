# KVM + QEMU + libvirt

We start by checking if KVM acceleration can be used by running the commands below:

```shell
$ sudo apt update
$ sudo apt -y install cpu-checker
$ kvm-ok
```

Then we proceed to installing and configuring the virtualization components by running the commands below:

```shell
$ sudo apt -y install bridge-utils libvirt-daemon-system qemu-kvm virt-manager virt-viewer
$ sudo usermod -aG kvm,libvirt $USER
```

After that, log out and log back in for the new group memberships to take effect.
