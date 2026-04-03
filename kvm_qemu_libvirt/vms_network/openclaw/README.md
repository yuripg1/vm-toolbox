# OpenClaw

## VM creation

First of all, we need to have the `ubuntu-24.04.4-live-server-amd64.iso` image in the `openclaw` directory.

Secondly, a distinction of commands to be executed in the host and the guest is done by using `[Host]` and `[OpenClaw-VM]` prefixes and indentation.

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

## OS configuration

After shutting down the VM, we'll start it again but this time with no graphical interface by running the commands below:

```shell
[Host]$ ./openclaw_start_vm.sh
```

Once the VM has booted up, we can then prepare the VM before installing OpenClaw by running the commands below:

```shell
[Host]$ ./openclaw_connect_via_ssh.sh
  [OpenClaw-VM]$ sudo apt update && sudo apt -y dist-upgrade
  [OpenClaw-VM]$ sudo apt -y install build-essential
  [OpenClaw-VM]$ curl -O https://nodejs.org/dist/v24.14.1/node-v24.14.1-linux-x64.tar.xz
  [OpenClaw-VM]$ tar -xf ./node-v24.14.1-linux-x64.tar.xz
  [OpenClaw-VM]$ sudo mv ./node-v24.14.1-linux-x64 /opt/node
  [OpenClaw-VM]$ sudo ln -s /opt/node/bin/node /usr/local/bin/node
  [OpenClaw-VM]$ sudo ln -s /opt/node/bin/npm /usr/local/bin/npm
  [OpenClaw-VM]$ rm -f ./node-v24.14.1-linux-x64.tar.xz
  [OpenClaw-VM]$ sudo ufw allow 22
  [OpenClaw-VM]$ sudo ufw enable
  [OpenClaw-VM]$ nano ~/.bashrc
```

Add the following line at the end of the `.bashrc` file in the guest:

```
export PATH="/opt/node/bin:$PATH"
```

After that, we reboot the OS by running the commands below:

```shell
  [OpenClaw-VM]$ exit
[Host]$ ./openclaw_reboot_vm.sh
```

## OpenClaw installation

After the OS has booted up again, we can finally go for the installation of OpenClaw with the command below:

```shell
[Host]$ ./openclaw_connect_via_ssh.sh
```

Right after installing OpenClaw, we already have a device to approve. Run the command below:

```shell
[OpenClaw-VM]$ openclaw devices list
```

Next, we replace the `<Request>` and run the command below:

```shell
[OpenClaw-VM]$ openclaw devices approve <Request>
```

## Telegram pairing

After you've created a Telegram bot and configured it in OpenClaw (this manual does not go over those steps), you'll want to initiate a conversation with the bot. Upon receiving the first message in Telegram, OpenClaw will require a "pairing" process. Run the command below to see your pending pairings:

```shell
[OpenClaw-VM]$ openclaw pairing list
```

Take note of the Telegram user ID that appears in the output because we will need it later on.

Now, replace the `<Code>` and run the command below to approve the pairing:

```shell
[OpenClaw-VM]$ openclaw pairing approve <Code>
```

## Telegram configuration

Now we need to tweak the Telegram integration so that OpenClaw prompts us when it needs approval for running commands (and also another change to stop the streaming of partial messages in Telegram).

Run the command below to edit `openclaw.json`:

```shell
[OpenClaw-VM]$ nano ~/.openclaw/openclaw.json
```

Inside `"channels"."telegram"`, add the following values (replacing `<TelegramUserID>`):

```
"streaming": "off",
"execApprovals": {
  "enabled": true,
  "target": "channel",
  "approvers": ["<TelegramUserID>"]
}
```

Then, we'll need to restart OpenClaw Gateway with the following command:

```shell
[OpenClaw-VM]$ openclaw gateway restart
```

---

Note 1: The steps described here assume that you've already installed the virtualization stack. If you haven't, please refer to **[KVM + QEMU + libvirt](../../)**.

Note 2: The steps described here assume that you've already configured a dedicated network for the VMs. If you haven't, please refer to **[VMs network](../)**.
