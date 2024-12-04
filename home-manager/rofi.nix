{ config, pkgs, lib, inputs, ... }:
{
  programs.rofi = {
    enable = true;
    font = "Unifont 12";
    location = "center";
  };
}
