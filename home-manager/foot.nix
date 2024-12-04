{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Unifont:size=12";
        term = "xterm-256color";
      };
        mouse = {
        hide-when-typing = "yes";
      };
      colors = {
      };
    };
  };
}
