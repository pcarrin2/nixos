{ config, lib, pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      unifont
      unifont_upper
      arkpandora_ttf
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Unifont" ];
      };
    };
    fontDir.enable = true;
  };
}
