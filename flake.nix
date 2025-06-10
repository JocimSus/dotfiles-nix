{
    description = "jocim's server";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };

    outputs = { nixpkgs, ... }@inputs:
    let
        lib = nixpkgs.lib;
        system = "x86_64-linux";
    in {

        ## System configs ##
        nixosConfigurations = {
            meow = lib.nixosSystem {
                inherit system;
                specialArgs = { inherit inputs; };
                modules = [ ./configuration.nix ];
            };
        };
    };
}
