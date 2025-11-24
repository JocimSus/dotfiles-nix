{
  description = "jocim was here";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
    { nixpkgs
    , home-manager
    , nur
    , ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      ## System configs ##
      nixosConfigurations = {
        meow = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs-stable; };
          modules = [
            ./hosts/msi-laptop/configuration.nix
            nur.modules.nixos.default # used in waydroid module
          ];
        };
        woof = lib.nixosSystem {
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
        jocim-server = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./hosts/server/home.nix ];
        };
      };

      packages.${system} = {
        inherit (inputs.prismlauncher.packages.${system}) prismlauncher;
      };

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
        c_dev = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            gcc
            clang-tools
            cmake
            gdb
          ];

          packages = with pkgs; [
            cppcheck # Static analysis
            doxygen # Documentation
            lcov # Code coverage
            pkg-config # Library discovery
          ];

          shellHook = ''
            echo "C development environment"
            echo "Compiler: $(gcc --version)"
          '';
        };
      };
      wotr = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          mono
          dotnet-sdk
          unityhub
          python314
        ];

        packages = with pkgs; [
          python314
        ];

        shellHook = ''
          export WrathPathDebug="/home/jocim-nix/Games/pathfinder-wotr/drive_c/Program Files (x86)/RUNE/Pathfinder Wrath of the Righteous Enhanced Edition/"

          echo "WrathPathDebug="$WrathPathDebug
        '';
      };
    };
}
