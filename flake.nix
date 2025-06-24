{
    description = "jocim was here";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        ags = {
            url = "github:aylur/ags/v1";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        prismlauncher = {
            url = "github:Diegiwg/PrismLauncher-Cracked";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        zen-browser = {
            url = "github:youwen5/zen-browser-flake";
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
                modules = [ ./configuration.nix ];
            };
        };

        ## User configs ##
        homeConfigurations = {
            jocim-nix = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = { inherit inputs; };
                modules = [ ./home.nix ];
            };
        };

        packages.${system} = {
            prismlauncher = inputs.prismlauncher.packages.${system}.prismlauncher;
        };

        devShells.${system} = {
          c_dev = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              gcc
              clang-tools
              cmake
              gdb
            ];

            packages = with pkgs; [
              cppcheck     # Static analysis
              doxygen      # Documentation
              lcov         # Code coverage
              pkg-config   # Library discovery
            ];

            shellHook = ''
              echo "C development environment"
              echo "Compiler: $(gcc --version)"
              '';
          };
        };   
    };    
}
