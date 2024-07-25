{ config, pkgs, lib, inputs, ... }:
{
  programs.bash = {
    enable = true;
    historyControl = [ "ignorespace" ];
    initExtra = ''
      PS1="\a\n\[\033[1;35m\]\! \[\033[1;34m\][\u@\h:\w]\$ \[\033[0m\]"
    '';
  };

}
