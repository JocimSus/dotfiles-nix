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
        pkgs = import nixpkgs { inherit system; };
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
                inherit pkgs;
                extraSpecialArgs = { inherit inputs; };
                modules = [ ./home.nix ];
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
