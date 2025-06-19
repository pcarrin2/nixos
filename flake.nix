{
  description = "Main system flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # Hardware support
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim config files
    neovim-config = {
      type = "github";
      owner = "pcarrin2";
      repo = "neovim_config";
      flake = false;
    };

    # yt-x: browse youtube from the terminal
    yt-x.url = "github:Benexl/yt-x";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, neovim-config, ... }@inputs:
    let inherit (self) outputs; in
    {
    nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs;};
      system = "x86-64_linux";
      modules = [
        ./system/configuration.nix
	      home-manager.nixosModules.home-manager
	      {
          home-manager.useGlobalPkgs = true;
	        home-manager.useUserPackages = true;
          home-manager.users.theta = import ./home-manager/home.nix;
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.backupFileExtension = "backup";
        }
        nixos-hardware.nixosModules.lenovo-thinkpad-t14s
      ];
    };
  };
}
