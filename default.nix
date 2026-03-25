{
  pkgs,
}:
let
  names = builtins.attrNames (builtins.readDir ./pkgs);
  filtered = builtins.filter (n: n != "default.nix") names;

  load =
    name:
    let
      v = pkgs.callPackage (./pkgs + "/${name}") { };
    in
    if builtins.isAttrs v && !(v ? type && v.type == "derivation") then v else { ${name} = v; };

in
builtins.foldl' (acc: name: acc // (load name)) { } filtered
