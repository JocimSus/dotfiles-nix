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

    mkdir -p $out/lib/gtnh-server/
    cp -r ./* $out/lib/gtnh-server/

    makeWrapper ${stdenv.shell} $out/bin/gtnh-server \
      --set-default JAVA_BIN ${lib.getExe jre_headless} \
      --set-default DATA_DIR "/var/lib/gtnh-server" \
      --run '
        if [ ! -d "$DATA_DIR" ]; then
          echo "Initializing server data directory at $DATA_DIR"
          mkdir -p "$DATA_DIR"
          for f in '"$out/lib/gtnh-server/"'{mods,config,journeymap,serverutilities,banned-ips.json,banned-players.json,ops.json,usercache.json,whitelist.json,server.properties,eula.txt,server-icon.png}; do
            [ -e "$f" ] && cp -r "$f" "$DATA_DIR"
          done

          for f in '"$out/lib/gtnh-server/"'{libraries,java9args.txt,forge*.jar,minecraft_server*.jar,lwjgl3ify-forgePatches.jar}; do
            [ -e "$f" ] && ln -s "$f" "$DATA_DIR"
          done
        fi

        cd $DATA_DIR

        echo "Starting GTNH Server"
        exec "$JAVA_BIN" $JVM_FLAGS '"${jvmFlags}"' \
        -jar '"$out/lib/gtnh-server/${forgeJar}"' \
        nogui "$@"
      '

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
