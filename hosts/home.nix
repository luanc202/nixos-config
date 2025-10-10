#
#  General Home-manager configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ home.nix *
#   └─ ./modules
#       ├─ ./programs
#       │   └─ default.nix
#       └─ ./services
#           └─ default.nix
#

{ pkgs, user, ... }:

{
  imports =                                   # Home Manager Modules
    (import ../modules/programs) ++
    (import ../modules/services);

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # Terminal
      ranger            # File Manager
      tldr              # Helper

      # Video/Audio
      mpv               # Media Player
      pavucontrol       # Audio Control

      # Apps
      appimage-run      # Runs AppImages on NixOS
      firefox           # Browser
      # brave             # Browser

      # File Management
      # gnome.file-roller # Archive Manager
      okular            # PDF Viewer
      unzip             # Zip Files
      unrar             # Rar Files
      zip               # Zip

      # General configuration
      #git              # Repositories
      killall          # Stop Applications
      #nano             # Text Editor
      pciutils         # Computer Utility Info
      #pipewire         # Sound
      usbutils         # USB Utility Info
      #wacomtablet      # Wacom Tablet
      wget             # Downloader
      #zsh              # Shell
      #
      # General home-manager
      libnotify        # Dependency for Dunst
      udiskie          # Auto Mounting
      #
      # Xorg configuration
      #xclip            # Console Clipboard
      #xorg.xev         # Input Viewer
      #xorg.xkill       # Kill Applications
      #xorg.xrandr      # Screen Settings
      #xterm            # Terminal
      #
      # Xorg home-manager
      #flameshot        # Screenshot
      #picom            # Compositer
      #sxhkd            # Shortcuts
      #
      # Wayland configuration
      #autotiling       # Tiling Script
      #grim             # Image Grabber
      #slurp            # Region Selector
      #swappy           # Screenshot Editor
      #swayidle         # Idle Management Daemon
      #wev              # Input Viewer
      #wl-clipboard     # Console Clipboard
      #wlr-randr        # Screen Settings
      xwayland         # X for Wayland
      #
      # Wayland home-manager
      #mpvpaper         # Video Wallpaper
      #pamixer          # Pulse Audio Mixer
      #swaybg           # Background
      #swaylock-fancy   # Screen Locker
      #waybar           # Bar
      #
      # Desktop
      #ansible          # Automation
      qbittorrent       # Torrents
      handbrake        # Encoder
      #
    ];
    file.".config/wall.jpg".source = ../modules/themes/catalina-night.jpg;
    pointerCursor = {                         # This will set cursor system-wide so applications can not choose their own
      gtk.enable = true;
      name = "Catppuccin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 16;
    };
    stateVersion = "25.05";
  };

  programs = {
    home-manager.enable = true;
  };

  gtk = {                                     # Theming
    enable = true;
    theme = {
      name = "Catppuccin-Dark";
      package = pkgs.catppuccin-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      #name = "JetBrains Mono Medium";
      name = "FiraCode Nerd Font Mono Medium";
    };                                        # Cursor is declared under home.pointerCursor
  };
}
