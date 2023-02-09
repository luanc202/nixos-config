#
#  Main system configuration. More information available in configuration.nix(5) man page.
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix *
#   └─ ./modules
#       ├─ ./editors
#       │   └─ default.nix
#       └─ ./shell
#           └─ default.nix
#

{ config, lib, pkgs, inputs, user, ... }:

{
  imports =
    (import ../modules/editors) ++          # Native of nix-community flake
    (import ../modules/shell);

  users.users.${user} = {                   # System User
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "kvm" "libvirtd" "plex" ];
    shell = pkgs.zsh;                       # Default shell
  };
  
  boot.initrd.kernelModules = [ "zstd" "btrfs" ];

  time.timeZone = "Brazil/Fortaleza";        # Time zone and internationalisation
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {                 # Extra locale settings that need to be overwritten
      LC_TIME = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";                          # or us/azerty/etc
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;
  #sound = {                                # Deprecated due to pipewire
  #  enable = true;
  #  mediaKeys = {
  #    enable = true;
  #  };
  #};

  fonts.fonts = with pkgs; [                # Fonts
    carlito                                 # NixOS
    vegur                                   # NixOS
    source-code-pro
    jetbrains-mono
    font-awesome                            # Icons
    corefonts                               # MS
    (nerdfonts.override {                   # Nerdfont Icons override
      fonts = [
        "FiraCode"
      ];
    })
  ];

  environment = {
    variables = {
      TERMINAL = "konsole";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [           # Default packages installed system-wide
      #vim
      git
      killall
      nano
      pciutils
      usbutils
      wget
      curl
      neovim
    ];
  };

  services = {
    printing = {                                # Printing and drivers for TS5300
      enable = true;
      #drivers = [ pkgs.cnijfilter2 ];          # There is the possibility cups will complain about missing cmdtocanonij3. I guess this is just an error that can be ignored for now. Also no longer need required since server uses ipp to share printer over network.
    };
    avahi = {                                   # Needed to find wireless printer
      enable = true;
      nssmdns = true;
      publish = {                               # Needed for detecting the scanner
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
    pipewire = {                            # Sound
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    openssh = {                             # SSH: secure shell (remote connection to shell of server)
      enable = true;                        # local: $ ssh <user>@<ip>
      allowSFTP = true;                     # SFTP: secure file transfer protocol (send file to server)
    };
    flatpak.enable = true;                  # download flatpak file from website - sudo flatpak install <path> - reboot if not showing up
  };

  nix = {                                   # Nix Package Manager settings
    settings ={
      auto-optimise-store = true;           # Optimise syslinks
    };
    gc = {                                  # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    package = pkgs.nixVersions.unstable;    # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true;        # Allow proprietary software.

  system = {                                # NixOS settings
    autoUpgrade = {                         # Allow auto update (not useful in flakes)
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "22.11";
  };
}