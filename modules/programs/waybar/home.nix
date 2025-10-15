# modules/programs/waybar-hm.nix

{ pkgs, ... }:

{
  # Configure the waybar program itself
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "sway-session.target";
    };
  };

  # Manage the custom script file
  home.file.".config/waybar/script/sink.sh" = {
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
}
