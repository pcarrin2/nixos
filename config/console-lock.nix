{ config, lib, pkgs, ... }:
{
  systemd.services."console-lock" = {
    enable = true;
    description = "Lock physical consoles when going to sleep";
    wantedBy = ["sleep.target"];
    script = ''
    USER=theta ${pkgs.vlock}/bin/vlock -an
    '';
  };
}
