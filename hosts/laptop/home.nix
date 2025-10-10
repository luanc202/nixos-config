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

    console = {
            font = "Lat2-Terminus16";
            keyMap = "us";                          # or us/azerty/etc
          };

  home = {                                # Specific packages for desktop
    packages = with pkgs; [
      # Utilities

      # Dependencies

      # Imported in default or from modules
      vesktop           # Comms           # See overlay default.nix
      ffmpeg           # Video Support
      #gphoto2          # Digital Photography

      # Packages I used in the past
    ];
  };

  services = {                            # Applets
    blueman-applet.enable = true;         # Bluetooth
  };
}
