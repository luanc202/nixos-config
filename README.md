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

# Where did I get most of these configs from?
- [MatthiasBenaets's Nix config](https://github.com/MatthiasBenaets/nixos-config)
- [ChrisTitusTech's hyprland](https://github.com/ChrisTitusTech/hyprland-titus)

## Install guide

### UEFI
*In these commands*
- Partition Labels:
  - Boot = "boot"
  - Home = "root"
- Partition Size:
  - Boot = 512MiB
  - Home = Rest

``` bash
  parted /dev/vda -- mklabel gpt
  parted /dev/vda -- mkpart primary 512MiB -8GiB
  parted /dev/vda -- mkpart ESP fat32 1MiB 512MiB
  parted /dev/vda -- set 2 esp
  mkfs.btrfs -L root /dev/vda1 -f
  mkfs.fat -F 32 -n boot /dev/vda2
```

## Installation
### UEFI
*In these commands*
- Mount partition with label ... on ...
  - "root" -> ~/mnt~
  - "boot" -> ~/mnt/boot~
``` bash
  mkdir -p /mnt
  mount /dev/vda1 /mnt
  btrfs subvolume create /mnt/root
  btrfs subvolume create /mnt/home
  btrfs subvolume create /mnt/nix
  umount /mnt

  mount -o compress=zstd,subvol=root /dev/vda1 /mnt
  mkdir /mnt/{home,nix}
  mount -o compress=zstd,subvol=home /dev/vda1 /mnt/home
  mount -o compress=zstd,noatime,subvol=nix /dev/vda1 /mnt/nix
  mkdir -p /mnt/boot/efi
  mount /dev/disk/by-label/boot /mnt/boot/efi
```

### Generate
*In these commands*
- Swap is enable:
  - Ignore if no swap or enough RAM
- Configuration files are generated @ ~/mnt/etc/nixos~
- Clone repository
``` bash
  nixos-generate-config --root /mnt
  nix-env -iA nixos.git
  git clone https://github.com/luanc202/nixos-config /mnt/etc/nixos/<name>

  # DO NOT FORGET THIS ONE OR BOOT WILL FAIL!!
  cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/nixos-config/hosts/<host>/.
```

### Possible Extra Steps
1. Switch specific host hardware-configuration.nix with generated ~/mnt/etc/nixos/hardware-configuration.nix~
2. Change existing network card name with the one in your system
   - Look in generated hardware-configuration.nix
   - Or enter ~$ ip a~
3. Change username in flake.nix
4. Set a ~users.users.${user}.initialPassword = ...~
   - Not really recommended. It's maybe better to follow last steps

### Install
*In these commands*
- Move into cloned repository
  - in this example ~/mnt/etc/nixos/<name>~
- Available hosts:
  - desktop
  - vm
``` bash
  cd /mnt/etc/nixos/<name>
  nixos-install --flake .#<host>
```

## Finalization
1. Set a root password after installation is done
2. Reboot without liveCD
3. Login
   1. If initialPassword is not set use TTY:
      - ~Ctrl - Alt - F1~
      - login as root
      - ~# passwd <user>~
      - ~Ctrl - Alt - F7~
      - login as user
4. Optional:
   - ~$ sudo mv <location of cloned directory> <prefered location>~
   - ~$ sudo chown -R <user>:users <new directory location>~
   - ~$ sudo rm /etc/nixos/configuration.nix~ - This is done because in the past it would auto update this config if you would have auto update in your configuration.
   - or just clone flake again do apply same changes.
5. Dual boot:
   - OSProber probably did not find your Windows partition after the first install
   - There is a high likelihood it will find it after:
     - ~$ sudo nixos-rebuild switch --flake <config path>#<host>~
6. Rebuilds:
   - ~$ sudo nixos-rebuild switch --flake <config path>#<host>~
   - For example ~$ sudo nixos-rebuild switch --flake ~/.setup#matthias~