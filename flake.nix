{
  description = "Main system flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let inherit (self) outputs; in
    {
    nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs;};
      system = "x86-64_linux";
      modules = [
        ./config/configuration.nix
	home-manager.nixosModules.home-manager
	{
          home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.users.theta = import ./home-manager/home.nix;
        }
      ];
    };
  };
}
