{
  description = "jocim's server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { nixpkgs, ... }@inputs:
    let
    lib = nixpkgs.lib;
  system = "x86_64-linux";
  in {
    nixosConfigurations = {
      woof = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [ ./configuration.nix ];
      };
    };
  };
}
