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

{ pkgs, ... }:

{
  imports =                                               # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [(import ../../modules/desktop/hyprland/default.nix)] ++ # Window Manager
    (import ../../modules/desktop/virtualisation) ++      # Virtual Machines & VNC
    (import ../../modules/hardware);                      # Hardware devices

    services = {
      blueman.enable = true;
    };

    console = {
        font = "Lat2-Terminus16";
        keyMap = "br-abnt2";                          # or us/azerty/etc
    };

    time.timeZone = "Brazil/Fortaleza";        # Time zone and internationalisation
    i18n = {
      defaultLocale = "pt_BR.UTF-8";
      extraLocaleSettings = {                 # Extra locale settings that need to be overwritten
        LC_TIME = "pt_BR.UTF-8";
        LC_MONETARY = "pt_BR.UTF-8";
      };

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;
    # initrd.kernelModules = [ "amdgpu" ];       # Video drivers

    loader = {
      timeout = 2;
      grub = {
        # grub config
        enable = true;

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
