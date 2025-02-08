{ config, lib, pkgs, ... }:
{
  systemd.services."console-lock" = {
    enable = true;
    description = "Lock physical consoles when going to sleep";
    wantedBy = ["sleep.target"];
    script = ''
    USER=theta VLOCK_MESSAGE=$(/etc/nixos/system/assets/terminal-gen-graphics) ${pkgs.vlock}/bin/vlock -an
    '';
  };
}
