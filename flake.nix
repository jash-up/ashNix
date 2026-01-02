{
  description = "A very basic flake, really";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs }: {
    nixosConfigurations = {
      ashPC = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	specialArgs = { inherit inputs; };
	modules = [
	  ./hosts/ashPC/ashPC.nix
	  ./hosts/ashPC/hardware-configuration.nix
	];
      };
      sash = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
      	specialArgs = { inherit inputs; };
      	modules = [
      	  ./hosts/sash/sash.nix
      	  ./hosts/sash/hardware-configuration.nix
      	];
      };
    };
  };
}
