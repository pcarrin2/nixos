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
      localConf = ''
<selectfont>
    <rejectfont>
        <pattern>
            <patelt name="family" >
                <string>Aerial</string>
            </patelt>
        </pattern>
    </rejectfont>
</selectfont>
      '';
    };
    fontDir.enable = true;
  };
}
