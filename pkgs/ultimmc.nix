{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "ultimmc";
  version = "1.0";

  src = pkgs.fetchurl {
    url = "https://nightly.link/UltimMC/Launcher/workflows/main/develop/mmc-cracked-lin64.zip";
    sha256 = "sha256-e0DO3NRpfJvfW3GgAULjTYjsnXNXzYpnyqaR5qgx8VM=";
  };

  nativeBuildInputs = [ pkgs.unzip pkgs.autoPatchelfHook pkgs.wrapGAppsHook ];

  buildInputs = [
    pkgs.qt5.qtbase
    pkgs.qt5.qtx11extras
    pkgs.qt5.qtsvg
    pkgs.zlib
    pkgs.libpng
    pkgs.xorg.libXrandr
  ];


  unpackPhase = ''
    unzip $src
    mv UltimMC $out
  '';

  installPhase = ''
    mkdir -p $out/bin
    ln -s $out/UltimMC $out/bin/ultimmc
  '';

  meta = with pkgs.lib; {
    description = "UltimMC Minecraft Launcher";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
