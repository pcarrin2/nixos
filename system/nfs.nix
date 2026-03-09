{ ... }:
{
  boot.supportedFilesystems = [ "nfs" ];
  fileSystems."/mnt/nas-movies" = {
    device = "squirrel-nas.local:/Movies";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" ];
  };
}
