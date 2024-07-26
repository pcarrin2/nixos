{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./borgbackup.nix
      ./console-lock.nix
      ./filesystems.nix
      ./fonts.nix
      ./home-manager.nix
      ./sound.nix
      ./users.nix
      ./zerotier.nix
      ./libvirt.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # EFI bootloader
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices.cryptroot.device = "/dev/disk/by-uuid/dc6aedcc-b301-4a34-833a-9f0100d3ceb3";
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  # Misc. hardware config
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
  hardware.opengl.enable = true;

  networking = {
    hostName = "thinkpad";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall.enable = false;
  };

  # Locale and internationalization
  # TODO: successfully change locale to something ASCII-only
  # TODO: get terminus font to actually work!
  i18n.defaultLocale = "en-US.ISO-8859-1";
  i18n.supportedLocales = [ "all" ];
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  time.timeZone = "America/Chicago";

  # Make Nix usable
  nix.settings.experimental-features = "nix-command flakes";

  # Disable channels
  nix.channel.enable = false;

  # System-wide packages
  environment.systemPackages = with pkgs; [
    # Editors
    vim
    neovim
    emacs
    # Web
    wget
    curl
    # Hardware info
    lshw
    # SSH
    openssh
    # File utilities
    gzip
    xz
    zip
    unzip
    binutils
    # Disk, partition, and filesystem utilities
    smartmontools
    parted
    ntfs3g
    # General utilities
    util-linux
    linux-firmware
    # Sound utilities
    alsa-utils
    # Development
    docker
    # Other
    vlock
    tun2socks
  ];

  environment.variables = { EDITOR = "vim"; NIXOS_OZONE_WL = "1"; };

  services.printing.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = "24.05"; # Never change this!

}

