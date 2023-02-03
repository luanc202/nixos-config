# My personal NixOS config files

## Still needs work

## What to do on a fresh install?
This:
``` bash
sudo su
git clone <this repo> /mnt/<path>
nixos-install --flake .#<host>
reboot
# on login
$ sudo rm -r /etc/nixos/configuration.nix
# move build to desired location
```