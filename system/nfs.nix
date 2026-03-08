{}:
{
  boot.supportedFilesystems = [ "nfs" ];
  fileSystems."/mnt/nas-movies" = {
    device = "192.168.1.46:/Movies";
    fsType = "nfs";
    options = [ "nfsvers=4.2" "x-systemd.automount" "noauto" ];
  };
}
