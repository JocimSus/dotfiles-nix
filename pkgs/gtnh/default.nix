{
  callPackage,
  lib,
  javaPackages,
}:
let
  versions = lib.importJSON ./versions.json;
  escapeVersion = builtins.replaceStrings [ "." ] [ "-" ];

  getJavaVersion =
    v:
    let
      attr = "openjdk${toString v}";
    in
    if builtins.hasAttr attr javaPackages.compiler then
      (builtins.getAttr attr javaPackages.compiler).headless
    else
      (builtins.getAttr "openjdk21" javaPackages.compiler).headless;
  getJavaMajor = v: if v < 17 then 8 else v;
  getJavaUrl = v: if v.javaVersion < 17 then v.java8Url else v.java17_2XUrl;
  getSha256 = v: if v.javaVersion < 17 then v.java8_checksum else v.java17_2X_checksum;

  mkPackages = versions:
    lib.mapAttrs' (version: value: {
      name = "gtnh-server-${escapeVersion version}";
      value = callPackage ./derivation.nix {
        version = version;
        url = getJavaUrl value;
        sha256 = getSha256 value;
        jre_headless = getJavaVersion (getJavaMajor value.javaVersion);
        inherit (value) javaVersion;
      };
    }) versions;

  java8Versions = lib.filterAttrs (_: v: v.javaVersion < 17) versions;
  java17Versions = lib.filterAttrs (_: v: v.javaVersion >= 17) versions;
in
{
  gtnh-java_8 = lib.recurseIntoAttrs (mkPackages java8Versions);
  gtnh-java_17_25 = lib.recurseIntoAttrs (mkPackages java17Versions);
}
