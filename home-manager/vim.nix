{ config, pkgs, lib, inputs, ... }:
{
  programs.vim = {
    enable = true;
    defaultEditor = true;
    settings = {
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      copyindent = true;
      number = true;
    };
    extraConfig = ''
      set autoindent
    '';
  };
}
