
{ config, pkgs, ... }:

let 
  user="luan";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
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

  # Set your time zone.
  time.timeZone = "Brazil/Fortaleza";
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    wget curl neovim git
  ];

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

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner"]; # Enable ‘sudo’ for the user.
  };

  home-manager.users.${user} - { pkgs, ... }: {
    home.packages = with pkgs; [
      zsh
      tmux
      zsh-syntax-highlighting
      zsh-autosuggestions
      zsh-history-substring-search
      zsh-completions
      zsh-theme-powerlevel10k
      zsh-z
    ]
  };

system = {
    channel = "https://nixos.org/channels/nixos-unstable";
    stateVersion = "22.11";
    autoUpgrade.enable = true;
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

}