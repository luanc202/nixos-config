#!/bin/bash

# partitioning
parted /dev/vda -- mklabel gpt
parted /dev/vda -- mkpart primary 512MiB -8GiB
parted /dev/vda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/vda -- set 2 esp

# making filesystems
mkfs.fat -F 32 -n boot /dev/vda2

mkfs.btrfs -L root /dev/vda1 -f
mkdir -p /mnt
mount /dev/vda1 /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
umount /mnt

# mounting
mount -o compress=zstd,subvol=root /dev/vda1 /mnt
mkdir /mnt/{home,nix}
mount -o compress=zstd,subvol=home /dev/vda1 /mnt/home
mount -o compress=zstd,noatime,subvol=nix /dev/vda1 /mnt/nix

mkdir -p /mnt/boot/efi
mount /dev/disk/by-label/boot /mnt/boot/efi

# nixos config
nixos-generate-config --root /mnt
nix-env -iA nixos.git
git clone https://github.com/luanc202/nixos-config.git /mnt/etc/nixos/nixos-config

echo "now you just need to enter /mnt/etc/nixos/nconfig and run nixos-install --flake .#<hostname>"