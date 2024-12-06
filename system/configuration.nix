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
      # i915 module here (or maybe under boot) gets terminus font to stick during boot
      kernelModules = [ "dm-snapshot" "i915" ];
      luks.devices.cryptroot.device = "/dev/disk/by-uuid/dc6aedcc-b301-4a34-833a-9f0100d3ceb3";
    };
    # i915 module here (or maybe under initrd) gets terminus font to stick during boot
    kernelModules = [ "kvm-intel" "acpi_call" "i915" ];
    # kernelParams = [ "acpi_backlight=native" "i915.enable_guc=2" ];
    extraModulePackages = [ ];
  };

  # Misc. hardware config
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
  hardware.graphics.enable = true;

  networking = {
    hostName = "thinkpad";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall.enable = false;
  };

  # Locale and internationalization
  i18n.defaultLocale = "en_US.utf8";
  i18n.supportedLocales = [ "all" ];
  console = {
    font = "ter-v16n";
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
    # Web
    wget
    curl
    dig
    tcpdump
    # Hardware info
    lshw
    pciutils
    usbutils
    # SSH
    openssh
    # File utilities
    gzip
    xz
    zip
    unzip
    binutils
    ripgrep
    file
    # Disk, partition, and filesystem utilities
    smartmontools
    parted
    ntfs3g
    # General utilities
    util-linux
    linux-firmware
    iotop
    dateutils
    openssl
    # Sound utilities
    alsa-utils
    # Development
    gcc
    docker
    # Other
    vlock
  ];

  environment.variables = { EDITOR = "vim"; NIXOS_OZONE_WL = "1"; };

  services.printing.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Needed by sway
  security.polkit.enable = true;

  system.stateVersion = "24.05"; # Never change this!

}

