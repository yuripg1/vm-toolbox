# Wireshark

To easily sniff packets between nodes in GNS3, you need to have Wireshark installed.

To install Wireshark with proper privileges, run the commands below:

```shell
$ sudo apt update
$ sudo apt -y install wireshark
```

When asked `Should non-superusers be able to capture packets?`, answer `Yes`.

After the installation is done, add your user to the `wireshark` group by running the command below:

```shell
$ sudo usermod -aG wireshark $USER
```

After that, log out and log back in for the new group membership to take effect.
