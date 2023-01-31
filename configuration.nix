# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Boot config
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;       # Get latest kernel
    initrd.kernelModules = ["amdgpu"];                # More on this later on (setting it for xserver)
    loader = {
      timeout = 2;  
      grub = {
        # grub config
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
        # useOSProber = true; # enable if you have other OS installed
      };
      # efi config
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi"; # if you have a separate /boot partition
      };
      # Use the systemd-boot EFI boot loader.
      systemd-boot = {
        enable = true;
      };
    };
  };

  # gc options & optimizing storage
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
      dates = "weekly";
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Brazil/Fortaleza";
  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # ADDED, config for certain packages
  nixpkgs.config = {
    allowUnfree = true;

    # Firefox and Chromium settings from https://nixos.wiki/wiki/Chromium
  };

  # List packages installed in system profile. To search, run:
  # $ nix search <term>
  environment.systemPackages = with pkgs; [
    wget curl neovim git zsh htop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Sound and hardware
  sound = {
    enable = true;
    mediaKeys.enable = true;
  };
  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      extraConfig = ''
        load-module module-switch-on-connect
      '';
    };
    bluetooth = {
      enable = true;
      hsphfpd.enable = true;         # HSP & HFP daemon
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };
  
  # Services
  services = {
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.luan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner"]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  
  # Did you read the comment?
  system = {
    channel = "https://nixos.org/channels/nixos-unstable";
    stateVersion = "22.11";
    autoUpgrade.enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false; # CUSTOMIZED

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us"; 
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver = {
  #   displayManager = {
  #     sddm = {
  #       enable = true;
  #       theme = "breeze";
  #     };
  #   };
  #   desktopManager = {
  #     plasma5.enable = true;
  #     default = "plasma5";
  #   };
  # };
}