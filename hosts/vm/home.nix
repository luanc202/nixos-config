#
#  Home-manager configuration for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./vm
#   │       └─ home.nix *
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#               └─ home.nix
#

{ pkgs, ... }:

{
  imports =
    [
      ../../modules/desktop/sway/home.nix  #Window Manager
    ];

  home = {                                  # Specific packages for desktop
    packages = with pkgs; [
      firefox
    ];

  };
}
