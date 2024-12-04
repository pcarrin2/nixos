{ config, lib, pkgs, ... }:
{
  systemd.services."console-lock" = {
    enable = true;
    description = "Lock physical consoles when going to sleep";
    wantedBy = ["sleep.target"];
    script = ''
    USER=theta VLOCK_MESSAGE=$(printf "$(cat /home/theta/.config/vlock_message)") ${pkgs.vlock}/bin/vlock -an
    '';
  };
}
