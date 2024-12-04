{config, lib, pkgs, ... } :
{
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
#      autoconnect = ["qemu://192.168.191.60"];
      uris = ["qemu+ssh://theta@192.168.191.60/system" "qemu+ssh://theta@192.168.191.60/session"];
    };
  };
}
