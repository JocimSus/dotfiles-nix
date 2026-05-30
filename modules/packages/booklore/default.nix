let
  pkgs = import <nixpkgs> { };
in
(import ./package.nix {
  inherit (pkgs)
    stdenvNoCC
    lib
    pkgs
    fetchFromGitHub
    buildNpmPackage
    ;
})
