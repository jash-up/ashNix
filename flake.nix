{
  description = "Ash's optimized NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    

    # Uncomment when ready to use Niri
    # niri.url = "github:sodiboo/niri-flake";
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, blender-bin, ... }@inputs:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.ashPC = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./ashPC.nix # Assuming your main config is here or renamed from ashPC.nix
          ./hardware-configuration.nix

	  { _module.args.inputs = inputs; }
          
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.ash = import ./home.nix;
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };
}
