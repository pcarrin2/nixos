{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  wayland.windowManager.sway = {
  enable = true;
  config = rec {
  systemd.enable = true;
  };
  };
  
  programs.waybar = {
  enable = true;
  settings = {
  topBar = {
  layer = "top";
  position = "top";
  height = 30;
  
  modules-left = [ "sway/workspaces", "sway/mode" ];
  modules-center = [ "sway/window" ];
  modules-right = [ "battery", "clock" ];
  };
  
  "sway/workspaces" = {
  disable-scroll = true;
  max-length = 50;
  };
  
  "battery" = {
  format = "{capacity}%";
  };
  
  "clock" = {
  interval = 1;
  format = "{:%F :%T}";
  };
  };
  
  style = ''
  * {
  border: none;
  border-radius: 0;
  font-family: Unifont;
  font-size: 12.0;
  background: #111111;
  color: #EEEEEE;
  }
  '';
  };
}
