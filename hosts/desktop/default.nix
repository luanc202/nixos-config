#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./desktop
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       ├─ ./desktop
#       │   ├─ ./hyprland
#       │   │   └─ default.nix
#       │   └─ ./virtualisation
#       │       └─ default.nix
#       ├─ ./programs
#       │   └─ games.nix
#       └─ ./hardware
#           └─ default.nix
#

{ pkgs, lib, user, ... }:

{
  imports =                                               # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [(import ../../modules/programs/games.nix)] ++        # Gaming
    [(import ../../modules/desktop/hyprland/default.nix)] ++ # Window Manager
    (import ../../modules/desktop/virtualisation) ++      # Virtual Machines & VNC
    (import ../../modules/hardware);                      # Hardware devices

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

  hardware = {
    
  };

  services = {
    blueman.enable = true;                      # Bluetooth
  };

}
