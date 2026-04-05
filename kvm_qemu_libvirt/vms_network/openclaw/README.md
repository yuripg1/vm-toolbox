# OpenClaw

## VM creation

First of all, we need to have the `ubuntu-24.04.4-live-server-amd64.iso` image in the `openclaw` directory.

Secondly, a distinction of commands to be executed in the host and the guest is done by using `[Host]$` and `[OpenClaw-VM]$` prefixes and also indentation.

Given this context, and from the `openclaw` directory, run the commands below to create the VM and boot it up:

```shell
[Host]$ bash ./openclaw_create_vm.sh
```

Follow the steps to install the OS. After everything is finished and the system is running idle, we'll shut it down to stop using the VNC display by running the command below:

```shell
[Host]$ bash ./openclaw_shutdown_vm.sh
```

---

## OS configuration

After shutting down the VM, we'll start it again but this time with no graphical interface by running the command below:

```shell
[Host]$ bash ./openclaw_start_vm.sh
```

Once the VM has booted up, we can then prepare the VM before installing OpenClaw by running the commands below:

```shell
[Host]$ bash ./openclaw_connect_via_ssh.sh
  [OpenClaw-VM]$ sudo apt update && sudo apt -y dist-upgrade
  [OpenClaw-VM]$ sudo apt -y install build-essential
  [OpenClaw-VM]$ cd ~
  [OpenClaw-VM]$ curl -O https://nodejs.org/dist/v24.14.1/node-v24.14.1-linux-x64.tar.xz
  [OpenClaw-VM]$ tar -xf ./node-v24.14.1-linux-x64.tar.xz
  [OpenClaw-VM]$ sudo mv ./node-v24.14.1-linux-x64 /opt/node
  [OpenClaw-VM]$ sudo ln -s /opt/node/bin/node /usr/local/bin/node
  [OpenClaw-VM]$ sudo ln -s /opt/node/bin/npm /usr/local/bin/npm
  [OpenClaw-VM]$ rm -f ./node-v24.14.1-linux-x64.tar.xz
  [OpenClaw-VM]$ printf "\nexport PATH=\"/opt/node/bin:\${PATH}\"\n" >> ~/.bashrc
  [OpenClaw-VM]$ sudo ufw allow 22/tcp
  [OpenClaw-VM]$ sudo ufw enable
  [OpenClaw-VM]$ exit
[Host]$ bash ./openclaw_reboot_vm.sh
```

---

## OpenClaw installation

After the OS has booted up again, we can finally go for the installation of OpenClaw with the commands below:

```shell
[Host]$ bash ./openclaw_connect_via_ssh.sh
  [OpenClaw-VM]$ curl -fsSL https://openclaw.ai/install.sh | bash
```

Right after installing OpenClaw, we already have a device to approve. Run the command below:

```shell
[OpenClaw-VM]$ openclaw devices list
```

Next, we replace the `<Request>` and run the command below:

```shell
[OpenClaw-VM]$ openclaw devices approve <Request>
```

---

## Secure access to the dashboard

By default, the dashboard is only accessible from `localhost`. In order to avoid unnecessary exposure, we can leave it like this and open a tunnel via SSH (from the host to the OpenClaw VM) to securely access the dashboard.

We start by opening the tunnel with the command below:

```shell
[Host]$ bash ./openclaw_open_tunnel_via_ssh.sh
```

Then, in the OpenClaw VM, we get the link to the dashboard (with the access token included) by running the command below:

```shell
[OpenClaw-VM]$ openclaw dashboard --no-open
```

Finally, you'll see a link in the shape of `http://127.0.0.1:18789/#token=<Token>` through which you can access the dashboard (provided you've established the tunnel like described above).

---

## Telegram pairing

After you've created a Telegram bot and configured it in OpenClaw (this manual does not go over those steps), you'll want to initiate a conversation with the bot. Upon receiving the first message in Telegram, OpenClaw will require a "pairing" process.

Run the command below to see your pending pairings:

```shell
[OpenClaw-VM]$ openclaw pairing list
```

Take note of the `telegramUserId` that appears in the output because we will need it later on.

Now, replace the `<Code>` and run the command below to approve the pairing:

```shell
[OpenClaw-VM]$ openclaw pairing approve <Code>
```

---

## Telegram tweaks

Now we need to tweak the Telegram integration so that OpenClaw prompts us when it needs approval for running commands and to also stop it from streaming partial messages, only sending messages when they are fully formed.

For that, we replace `<TelegramUserID>` with the value we annotated previously and run the commands below:

```shell
[OpenClaw-VM]$ openclaw config set channels.telegram.streaming off
[OpenClaw-VM]$ openclaw config set channels.telegram.execApprovals.enabled true
[OpenClaw-VM]$ openclaw config set channels.telegram.execApprovals.target channel
[OpenClaw-VM]$ openclaw config set channels.telegram.execApprovals.approvers[0] <TelegramUserID>
[OpenClaw-VM]$ openclaw gateway restart
```

---

Note 1: The steps described here assume that you've already installed the virtualization stack. If you haven't, please refer to **[KVM + QEMU + libvirt](../../)**.

Note 2: The steps described here assume that you've already configured a dedicated network for the VMs. If you haven't, please refer to **[VMs network](../)**.
