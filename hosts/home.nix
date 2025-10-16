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
      networkmanager
      # Video/Audio
      mpv               # Media Player
      pavucontrol       # Audio Control

      # Apps
      appimage-run      # Runs AppImages on NixOS
      firefox           # Browser
      # brave             # Browser

      # File Management
      # gnome.file-roller # Archive Manager
      kdePackages.okular            # PDF Viewer
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

      wezterm
    ];

    # Manage the custom script file
    file.".config/waybar/script/sink.sh" = {
      text = ''
        #!/bin/sh
        # ... your script content remains the same ...
        ID1=$(awk '/ Built-in Audio Analog Stereo/ {sub(/.$/,"",$2); print $2 }' <(${pkgs.wireplumber}/bin/wpctl status) | head -n 1)
        ID2=$(awk '/ S10 Bluetooth Speaker/ {sub(/.$/,"",$2); print $2 }' <(${pkgs.wireplumber}/bin/wpctl status) | sed -n 2p)

        HEAD=$(awk '/ Built-in Audio Analog Stereo/ { print $2 }' <(${pkgs.wireplumber}/bin/wpctl status | grep "*") | sed -n 2p)
        SPEAK=$(awk '/ S10 Bluetooth Speaker/ { print $2 }' <(${pkgs.wireplumber}/bin/wpctl status | grep "*") | head -n 1)

        if [[ $HEAD = "*" ]]; then
          ${pkgs.wireplumber}/bin/wpctl set-default $ID2
          echo -e "{\"text\":\""蓼"\"}"
        elif [[ $SPEAK = "*" ]]; then
          ${pkgs.wireplumber}/bin/wpctl set-default $ID1
          echo -e "{\"text\":\"""\"}"
        fi
      '';
      executable = true;
    };
    file.".config/wall.jpg".source = ../modules/themes/wall.jpg;
    file.".config/waybar" = {
      source = ../rsc/config/waybar;
      recursive = true;
    };
    file.".config/dunst" = {
        source = ../rsc/config/dunst;
        recursive = true;
       };
    file.".config/fish" = {
        source = ../rsc/config/fish;
        recursive = true;
    };
    file.".config/hypr" = {
        source = ../rsc/config/hypr;
        recursive = true;
    };
    file.".config/ranger" = {
         source = ../rsc/config/ranger;
         recursive = true;
       };
    file.".config/rofi" = {
        source = ../rsc/config/rofi;
        recursive = true;
    };
    file.".config/starship" = {
        source = ../rsc/config/starship;
        recursive = true;
    };
    file.".config/swaylock" = {
        source = ../rsc/config/swaylock;
        recursive = true;
    };
    file.".config/wezterm" = {
        source = ../rsc/config/wezterm;
        recursive = true;
    };
    file.".config/wlogout" = {
        source = ../rsc/config/wlogout;
        recursive = true;
    };

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
