{
    description = "jocim was here";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        # hyprland.url = "github:hyprwm/Hyprland";

        ags = {
            url = "github:aylur/ags/v1";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        prismlauncher = {
            url = "github:Diegiwg/PrismLauncher-Cracked";
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
            meow = lib.nixosSystem {
                inherit system;
                specialArgs = { inherit inputs; };
                modules = [ ./hosts/jocim-nix/configuration.nix ];
            };
        };

        ## User configs ##
        homeConfigurations = {
            jocim-nix = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = { inherit inputs system; };
                modules = [ ./hosts/jocim-nix/home.nix ];
            };
        };

        packages.${system} = {
            prismlauncher = inputs.prismlauncher.packages.${system}.prismlauncher;
        };
    };
}