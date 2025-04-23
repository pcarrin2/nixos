{ config, pkgs, lib, inputs, osConfig, ... }:
{
  imports = [ 
    ./tmux.nix 
    ./bash.nix
    ./virtualization.nix
    ./sway.nix
    ./foot.nix
    ./vim.nix
    ./rofi.nix
  ];
  
  home = {
    username = "theta";
    homeDirectory = "/home/theta";

    packages = with pkgs; [
      # GUI
      firefox
      signal-desktop
      thunderbird
      # VPN connection
      networkmanager-openconnect
      # Notifications
      libnotify
      # Editor
      neovim
      # Wayland utils
      wl-clipboard
      slurp
      wayshot
      # TUI messaging
      iamb
      w3m
      alpine
      # Sound utilities
      pamixer
      # Media and music
      mplayer
      mpv
      yt-dlp
      id3v2
      ytfzf
      cava
      # Pictures 
      fim
      inkscape
      fbcat
      # Passwords, authentication
      pass
      pinentry-tty
      keepassxc
      # Rust
      cargo
      rustc
      rust-analyzer
      # Python 3
      python3
      virtualenv
      # Github
      gh
      # Art
      processing
      darktable
      # Silly
      neofetch
      pipes
      cmatrix
      cowsay
      fortune
    ];

    file.".config/nvim/" = {
      source = "${inputs.neovim-config}";
      recursive = true;
    };
  };

  services.systembus-notify.enable = true; # for notifications!

  programs.home-manager.enable = true;
  programs.git.enable = true;

  systemd.user.startServices = "sd-switch"; # systemd switcher for home manager

  home.stateVersion = osConfig.system.stateVersion;
}
