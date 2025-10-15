#
# Bar
#

{ pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    waybar
  ];

  nixpkgs.overlays = [                                      # Waybar needs to be compiled with the experimental flag for wlr/workspaces to work
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        patchPhase = ''
          substituteInPlace src/modules/wlr/workspace_manager.cpp --replace "zext_workspace_handle_v1_activate(workspace_handle_);" "const std::string command = \"hyprctl dispatch workspace \" + name_; system(command.c_str());"
        '';
      });
    })
  ];

  home-manager.users.luan = {                           # Home-manager waybar config
    programs.waybar = {
      enable = true;
      systemd ={
        enable = true;
        target = "sway-session.target";                     # Needed for waybar to start automatically
      };

         home.file.".config/waybar/script/sink.sh" = {              # Custom script: Toggle speaker/headset
      text = ''
        #!/bin/sh

        ID1=$(awk '/ Built-in Audio Analog Stereo/ {sub(/.$/,"",$2); print $2 }' <(${pkgs.wireplumber}/bin/wpctl status) | head -n 1)
        ID2=$(awk '/ S10 Bluetooth Speaker/ {sub(/.$/,"",$2); print $2 }' <(${pkgs.wireplumber}/bin/wpctl status) | sed -n 2p)

        HEAD=$(awk '/ Built-in Audio Analog Stereo/ { print $2 }' <(${pkgs.wireplumber}/bin/wpctl status | grep "*") | sed -n 2p)
        SPEAK=$(awk '/ S10 Bluetooth Speaker/ { print $2 }' <(${pkgs.wireplumber}/bin/wpctl status | grep "*") | head -n 1)

        if [[ $HEAD = "*" ]]; then
          ${pkgs.wireplumber}/bin/wpctl set-default $ID2
          echo -e "{\"text\":\""蓼"\"}"
        elif [[ $SPEAK = "*" ]]; then
          ${pkgs.wireplumber}/bin/wpctl set-default $ID1
          echo -e "{\"text\":\"""\"}"
        fi
      '';
      executable = true;
    };
  };
};
}
