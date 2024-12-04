{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    config = {
      modifier = "Mod4";
      defaultWorkspace = "workspace number 1";
      bars = [
        {
          command = "waybar";
          id = "topBar";
        }
      ];
      window.titlebar = false;
      window.border = 1;
      menu = "\"rofi -i -modi drun,run,window -show drun\"";
    };
    
  };
  
  programs.waybar = {
  enable = true;
  systemd.enable = true;
  settings = {
    topBar = rec {
      layer = "top";
      position = "top";
      height = 24;
  
      modules-left = [ "sway/workspaces" ];
      modules-center = [ "sway/window" ];
      modules-right = [ "battery" "custom/spacer" "clock" ];

      battery = {
        format = "{capacity}%";
      };

      "custom/spacer" = {
        format = " | ";
        interval = "once";
      };
      
      clock = {
        interval = 1;
        format = "{:%F %H:%M:%S} ";
      };
    };
  
  };
  
  style = ''
    * {
      border: none;
      border-radius: 0;
      font-family: Unifont;
      font-size: 12.0pt;
      background: inherit;
      color: #EEEEEE;
      margin: 0px 2px;
      padding: 0px;
    }

    window#waybar {
      background-color: #333333;
    }

    #workspaces button:hover {
      border: none;
      box-shadow: none;
      background-color: #555555;
    }
  '';
  };
}
