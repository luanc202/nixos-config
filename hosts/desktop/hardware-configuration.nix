#
# Hardware settings for my B550M Desktop
#
# flake.nix
#  └─ ./hosts
#      └─ ./desktop
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

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "uas" "sd_mod" ];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelModules = [ "kvm-amd"];
  boot.extraModulePackages = with config.boot.kernelPackages; [ ];

  fileSystems."/" = {
      device = "/dev/disk/by-uuid/1fd1ba2f-4552-407e-997f-3b9548564077";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=root" "autodefrag" "noatime" ];
    };

  fileSystems."/home" = { 
    device = "/dev/disk/by-uuid/1fd1ba2f-4552-407e-997f-3b9548564077";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/nix" = { 
    device = "/dev/disk/by-uuid/1fd1ba2f-4552-407e-997f-3b9548564077";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  fileSystems."/mnt/hdd" =
    { #device = "/dev/disk/by-uuid/7491ea96-a62d-4202-ada7-8d0310dfc967";
      device = "/dev/disk/by-label/hdd";
      fsType = "ntfs";
      options = [ "nofail" ];
    };

  fileSystems."/mnt/KD512" =
    {
      device = "/dev/disk/by-label/KD512";
      fsType = "ntfs";
      options = [ "nofail" ];
    };

  fileSystems."/mnt/nvme2" =
    {
      device = "/dev/disk/by-label/nvme2";
      fsType = "btrfs";
      options = [ "nofail" ];
    };

  # swapDevices =
  #  [
  #    {
  #      device = "/dev/disk/by-label/swap";
  #    }
  #  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  hardware.cpu.amd.updateMicrocode = true;

  networking = {
    # useDHCP = false;                            # Deprecated
    hostName = "desktop";
    #networkmanager.enable = true;
    # enableIPv6 = false;
    # interfaces = {
    #   enp2s0 = {                                # Change to correct network driver
    #     # useDHCP = true;                       # Disabled because fixed ip
    #     ipv4.addresses = [ {                    # Ip settings: *.0.50 for main machine
    #       address = "192.168.0.50";
    #       prefixLength = 24;
    #     } ];
    #   };
      #wlp2s0.useDHCP = true;                   # Wireless card
    # };
    # defaultGateway = "192.168.0.1";
    # nameservers = [ "192.168.0.4" "1.1.1.1"];            # Pi-Hole DNS
    #nameservers = [ "1.1.1.1" "1.0.0.1" ];     # Cloudflare (when Pi-Hole is down)
  };
}
