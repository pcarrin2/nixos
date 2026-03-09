{ ... }:
{
  boot.supportedFilesystems = [ "nfs" ];
  fileSystems."/mnt/nas" = {
    device = "squirrel-nas.local:/Squirrel";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" ];
  };
}
