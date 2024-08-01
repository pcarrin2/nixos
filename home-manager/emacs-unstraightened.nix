{
  config,
  pkgs,
  lib,
  inputs,
}: {
  imports = [ inputs.unstraightened.hmModule ];
  
  programs.doom-emacs = {
    enable = true;
    doomDir = inputs.doom-config;
    extraPackages = epkgs: [
      epkgs.treesit-grammars.with-all-grammars
      epkgs.rust-mode
    ];
    
  };

}
