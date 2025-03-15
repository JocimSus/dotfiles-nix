{

    description = ":3";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, home-manager, ... }@inputs:
    let
        lib = nixpkgs.lib;
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
    in {

        ## System configs ##
        nixosConfigurations = {
            beam = lib.nixosSystem {
                inherit system;
                specialArgs = { inherit inputs; };
                modules = [ ./configuration.nix ];
            };
        };

        ## User configs ##
        homeConfigurations = {
            kaupec1 = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = { inherit inputs; };
                modules = [ ./home.nix ];
            };
        };
    };
}
