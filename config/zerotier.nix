{ config, lib, pkgs, ... }:
{
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "8850338390ed80aa"
    ];
  };
}
