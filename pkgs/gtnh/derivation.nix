{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  unzip,

  jre_headless,
  version,
  url,
  sha256,
  javaVersion,
}:
let
  isJava8 = javaVersion < 17;
  jvmFlags =
    if isJava8 then
      "-XX:+UseStringDeduplication -XX:+UseCompressedOops \
       -XX:+UseCodeCacheFlushing -Dfml.readTimeout=180"
    else
      "-Dfml.readTimeout=180 @java9args.txt";

  forgeJar =
    if isJava8 then "forge-1.7.10-10.13.4.1614-1.7.10-universal.jar" else "lwjgl3ify-forgePatches.jar";
in
stdenv.mkDerivation {
  pname = "gtnh-server";
  inherit version;

  src = fetchurl {
    inherit url sha256;
  };

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  unpackPhase = ''
    runHook preUnpack

    unzip $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/gtnh/
    cp -r ./* $out/lib/gtnh/

    makeWrapper ${stdenv.shell} $out/bin/gtnh \
      --set-default JAVA_BIN ${lib.getExe jre_headless} \
      --run 'exec "$JAVA_BIN" '"${jvmFlags}"' -jar '"$out/lib/gtnh/${forgeJar}"' nogui "$@"'

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.py;
  };

  meta = {
    description = "Greg Tech New Horizons Server";
    homepage = "https://www.gtnewhorizons.com/";
    license = lib.licenses.unfreeRedistributable;
    platforms = lib.platforms.unix;
  };
}
