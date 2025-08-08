{
  description = "jocim's server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: 
  let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
  in {
    nixosConfigurations = {
      woof = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [ 
          ./configuration.nix 
          inputs.vscode-server.nixosModules.default
        ];
      };
    };

    homeConfigurations = {
      jocim-server = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home.nix ];
      };
    };
    devShells.${system} =
        let
        fhs = pkgs.buildFHSEnv {
          name = "fhs-shell";
          targetPkgs = pkgs: [pkgs.python3Full pkgs.graphviz];
        };
        in {
          default = fhs.env;
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
