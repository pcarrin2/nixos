{ config, lib, pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      unifont
      unifont_upper
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Unifont" ];
      };
    };
    fontDir.enable = true;
  };
}
