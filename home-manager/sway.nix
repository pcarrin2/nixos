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
    extraConfig = ''
      output * background #433a96 solid_color
      bindsym Print exec wayshot --stdout -s "$( slurp )" | wl-copy
      bindsym XF86AudioMute exec pamixer -t
      bindsym XF86AudioRaiseVolume exec pamixer -i 5
      bindsym XF86AudioLowerVolume exec pamixer -d 5
      bindsym Shift+XF86AudioRaiseVolume exec pamixer -i 1
      bindsym Shift+XF86AudioLowerVolume exec pamixer -d 1
    '';
    config = {
      modifier = "Mod4";
      defaultWorkspace = "workspace number 1";
      # waybar will generate a status bar; sway's `bars` list needs to be empty or else there are two bars
      bars = [];
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
      background-color: #BA4686;
    }

    #workspaces button.focused {
      background-color: #4686BA;
    }
  '';
  };

  services.mako = {
    enable = true;
  };
}
