{

    description = "jocim was here";

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
        pkgs = import nixpkgs { inherit system; };
    in {

        ## System configs ##
        nixosConfigurations = {
            jocim-nix = lib.nixosSystem {
                inherit system;
                specialArgs = { inherit inputs; };
                modules = [ ./hosts/jocim-nix/configuration.nix ];
            };
            beam = lib.nixosSystem {
                inherit system;
                specialArgs = { inherit inputs; };
                modules = [ ./hosts/kaupec1/configuration.nix ];
            };
        };

        ## User configs ##
        homeConfigurations = {
            jocim-nix = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = { inherit inputs; };
                modules = [ ./hosts/jocim-nix/home.nix ];
            };
            kaupec1 = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = { inherit inputs; };
                modules = [ ./hosts/kaupec1/home.nix ];
            };
        };

        ## AGS ##
        # Need to built first, trying out the home manager way first.
#         packages.${system}. default = pkgs.stdenvNoCC.mkDerivation rec {
#             name = "my-shell";
#             src = ./.;
#
#             nativeBuildInputs = [
#                 inputs.ags.packages.${system}.default
#                 pkgs.wrapGAppsHook
#                 pkgs.gobject-introspection
#             ];
#
#             buildInputs = with inputs.astal.packages.${system}; [
#                 io
#                 astal3
#                 apps
#                 auth
#                 battery
#                 bluetooth
#                 cava
#                 greet
#                 hyprland
#                 mpris
#                 network
#                 notifd
#                 powerprofiles
#                 river
#                 tray
#                 wireplumber
#                 # any other package
#             ];
#
#             installPhase = ''
#                 mkdir -p $out/bin
#                 ags bundle app.ts $out/bin/${name}
#             '';
#         };
    };

}
