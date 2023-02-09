#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./vm
#   │       ├─ default.nix *
#   │       └─ hardware-configuration.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#               └─ bspwm.nix
#

{ config, pkgs, lib, user, ... }:

{
  imports =                                   # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++                # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [(import ../../modules/desktop/sway/default.nix)];     # Window Manager


  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;
    # initrd.kernelModules = [ "amdgpu" ];       # Video drivers

    loader = {
      timeout = 2;  
      grub = {
        # grub config
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
        useOSProber = true; # enable if you have other OS installed
      };
      # efi config
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi"; # if you have a separate /boot partition
      };
      # systemd-boot = { # Disabled because using GRUB
      #   enable = true;
      # };
    };
  };
}
