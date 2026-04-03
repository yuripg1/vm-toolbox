# GNS3

Run the commands below:

```shell
$ sudo add-apt-repository -y ppa:gns3/ppa
$ sudo apt update
$ sudo apt -y install dynamips gns3-gui gns3-server
```

When asked `Should non-superusers be able to run GNS3?`, answer `Yes`.

Then continue by running the commands below:

```shell
$ sudo usermod -aG ubridge $USER
```

After that, log out and log back in for the new group memberships to take effect.

---

Note: The steps describe here assume you've already installed the virtualization stack. If you haven't, please refer to **[KVM + QEMU + libvirt](../README.md)**.
