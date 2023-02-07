#
#  Screen color temperature changer
#
{ config, lib, pkgs, ...}:

{
  config = lib.mkIf (config.xsession.enable) {      # Only evaluate code if using X11
    services = {
      redshift = {
        enable = true;
        temperature.night = 3000;
        latitude = -2.522924;
        longitude = -44.209460;
      };
    };
  }; 
}
