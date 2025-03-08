{

    description = "Geralt was here";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hyprland.url = "github:hyprwm/Hyprland";

        ags.url = "github:aylur/ags";
    };

    outputs = { nixpkgs, home-manager, ... }@inputs:
    let
        lib = nixpkgs.lib;
        system = "x86_64-linux";
    in {
        # Multiple system configs here
        nixosConfigurations = {
            nixos = lib.nixosSystem {
                inherit system;
                specialArgs = { inherit inputs; };
                modules = [ ./configuration.nix ];
            };
        };

        # Multiple user configs here
        homeConfigurations = {
            jocim-nix = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs { inherit system; };
                extraSpecialArgs = { inherit inputs; };
                modules = [ ./home.nix ];
            };
        };
    };

}
