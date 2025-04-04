# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/71d4284f-8f72-4bd5-b6ac-fc1bbe4f2728";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/AA55-C627";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" "umask=077" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/61f0ae0e-ddbb-4749-90e0-9831acdcb5b3";
      fsType = "ext4";
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/81647a77-bcac-4ba4-b734-6c3609d7d71c";
      fsType = "ext4";
    };

  swapDevices = [ {
    device = "/dev/disk/by-uuid/59bba55b-2c26-46ce-9a76-ecca9d83faf6";
 } ];

}
