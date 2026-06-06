{
  description = "jocim was here";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-25_05.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    prismlauncher = {
      url = "github:diegiwg/prismlauncher-cracked";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      home-manager-stable,
      nur,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      lib-stable = nixpkgs-stable.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-25_05 = import inputs.nixpkgs-25_05 {
        inherit system;
        config.allowUnfree = true;
      };

      overlay = final: prev: {
        jocim = import ./default.nix {
          pkgs = final;
        };
      };
    in
    {
      ## Modules ##
      modules = lib.genAttrs [ "nixos" ] (_: {
        jocim = {
          nixpkgs.overlays = [ overlay ];
        };
      });

      ## System configs ##
      nixosConfigurations = {
        meow = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs-stable pkgs-25_05; };
          modules = [
            ./hosts/msi-laptop/configuration.nix
            nur.modules.nixos.default # used in waydroid module
            inputs.self.modules.nixos.jocim
          ];
        };
        woof = lib-stable.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/server/configuration.nix
          ];
        };
      };

      ## User configs ##
      homeConfigurations = {
        jocim-nix = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./hosts/msi-laptop/home.nix ];
        };
        jocim-server = home-manager-stable.lib.homeManagerConfiguration {
          pkgs = pkgs-stable;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./hosts/server/home.nix ];
        };
      };

      legacyPackages.${system} = (pkgs.extend overlay).jocim;

      devShells.${system} = {
        default =
          (pkgs.buildFHSEnv {
            name = "fhs";
            targetPkgs =
              pkgs: with pkgs; [
                python312Packages.pip
                python312
                graphviz
              ];
          }).env;
        java = pkgs.mkShell {
          buildInputs = [
            pkgs.gradle
            pkgs.jdk17
          ];

          NIX_LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            pkgs.stdenv.cc.cc
            pkgs.openssl
          ];

          NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
        };
      };
    };
}
