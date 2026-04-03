# VMs network

From the `vms_network` directory (this one), run the commands below:

```shell
$ virsh net-define ./vms_network.xml
$ virsh net-start vms
$ virsh net-autostart vms
```

---

Note: The steps describe here assume you've already installed the virtualization stack. If you haven't, please refer to **[KVM + QEMU + libvirt](../)**.
