# OpenClaw

First of all, we need to have the `ubuntu-24.04.4-live-server-amd64.iso` image in the `openclaw` directory.

Secondly, a distinction of commands to be executed in the host and the guest is done by using `[Host]` and `[Guest]` prefixes and indentation.

Then, from the `openclaw` directory, run the commands below to create the VM and boot it up:

```shell
[Host]$ chmod +x ./*.sh
[Host]$ ./openclaw_create_vm.sh
```

Follow the steps to finish the installation of the OS. After that, When going for a reboot, you'll need to eject the installation media. To determine which disk to eject, run the command below:

```shell
[Host]$ virsh domblklist openclaw-vm
```

After determining which target contains the installation media, replace `<Target>` and run the command below to eject it:

```shell
[Host]$ virsh detach-disk openclaw-vm <Target> --config
```

Then, you can continue with the reboot of the OS, but when it boots up again we will shutdown the VM with the command below:

```shell
[Host]$ ./openclaw_shutdown_vm.sh
```

After shutting down the VM, we'll start it again but this time with no graphical interface by running the commands below:

```shell
[Host]$ ./openclaw_start_vm.sh
```

Once the VM has booted up, we can then prepare the VM before installing OpenClaw by running the commands below:

```shell
[Host]$ ./openclaw_connect_via_ssh.sh
  [Guest]$ sudo apt update && sudo apt -y dist-upgrade
  [Guest]$ sudo apt -y install build-essential
  [Guest]$ curl -O https://nodejs.org/dist/v24.14.1/node-v24.14.1-linux-x64.tar.xz
  [Guest]$ tar -xf ./node-v24.14.1-linux-x64.tar.xz
  [Guest]$ sudo mv ./node-v24.14.1-linux-x64 /opt/node
  [Guest]$ sudo ln -s /opt/node/bin/node /usr/local/bin/node
  [Guest]$ sudo ln -s /opt/node/bin/npm /usr/local/bin/npm
  [Guest]$ rm -f ./node-v24.14.1-linux-x64.tar.xz
  [Guest]$ sudo ufw allow 22
  [Guest]$ sudo ufw enable
  [Guest]$ nano ~/.bashrc
```

Add the following line at the end of the `.bashrc` file in the guest:

```
export PATH="/opt/node/bin:$PATH"
```

After that, we reboot the OS by running the commands below:

```shell
  [Guest]$ exit
[Host]$ ./openclaw_reboot_vm.sh
```

After the OS has booted up again, we can finally go for the installation of OpenClaw with the command below:

```shell
[Host]$ ./openclaw_connect_via_ssh.sh
```

Right after installing OpenClaw, we already have a device to approve. Run the command below:

```shell
[Guest]$ openclaw devices list
```

Next, we replace the `<Request>` and run the command below:

```shell
$ openclaw devices approve <Request>
```

---

Note 1: The steps described here assume that you've already installed the virtualization stack. If you haven't, please refer to **[KVM + QEMU + libvirt](../../README.md)**.

Note 2: The steps described here assume that you've already configured a dedicated network for the VMs. If you haven't, please refer to **[VMs network](../README.md)**.
