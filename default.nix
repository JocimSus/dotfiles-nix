{
  pkgs,
}:
let
  names = builtins.attrNames (builtins.readDir ./pkgs);
  filtered = builtins.filter (n: n != "default.nix") names;
in
builtins.listToAttrs (
  map (name: {
    inherit name;
    value = pkgs.callPackage (./pkgs + "/${name}") { };
  }) filtered
)
