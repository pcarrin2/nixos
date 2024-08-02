{ config, lib, pkgs, ... }:
{
  users.users.theta = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "libvirtd" ];
  };
}
