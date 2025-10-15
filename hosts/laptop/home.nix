#
#  Home-manager configuration for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./desktop
#   │       └─ ./home.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./hyprland
#               └─ home.nix
#

{ pkgs, ... }:

{
  imports =
    [
      ../../modules/desktop/hyprland/home.nix  # Window Manager
    ];

  home = {                                # Specific packages for desktop
    packages = with pkgs; [

      # Utilities
      cbatticon        # Battery Notifications
      light            # Display Brightness
      simple-scan      # Scanning

      # Dependencies


    ];
  };

  services = {                            # Applets
    blueman.enable = true;
    blueman-applet.enable = true;         # Bluetooth
  };
}
