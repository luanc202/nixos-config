#
# Hardware settings for a general VM.
# Works on QEMU Virt-Manager and Virtualbox
#
# flake.nix
#  └─ ./hosts
#      └─ ./vm
#          └─ hardware-configuration.nix *
#
# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
#

{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "xhci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "zstd" "btrfs" "amdgpu" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/root";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" ];
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices = [ ];

  networking = {
    useDHCP = false;                        # Deprecated
    hostName = "vm";
    interfaces = {
      enp0s3.useDHCP = true;
    };
  };

  hardware.cpu.amd.updateMicrocode = true;
  #virtualisation.virtualbox.guest.enable = true;     #currently disabled because package is broken
}
