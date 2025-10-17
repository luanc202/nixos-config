# Waybar config

{ programs, pkgs, ... }:

{
  # Apply the overlay to compile waybar with experimental features


  # Configure the waybar program itself
  programs.waybar = {
    enable = true;
  };

}
