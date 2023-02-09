#
#  Apps
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ home.nix
#   └─ ./modules
#       └─ ./apps
#           └─ default.nix *
#               └─ ...
#

[
   ./rofi.nix
   #./waybar.nix
   #./games.nix
]
# Waybar.nix is pulled from modules/desktop/..
# Games.nix is pulled from desktop/default.nix
