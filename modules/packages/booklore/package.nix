{
  stdenvNoCC,
  lib,
  pkgs,

  fetchFromGitHub,
  buildNpmPackage,
}:

let
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "booklore-app";
    repo = "booklore";
    rev = "v${version}";
    hash = "sha256-kC3M1sE4fjWKru8pATd6A9doTV59puraYEfDifMr/cE=";
  };

  ui = buildNpmPackage {
    pname = "booklore-ui";
    inherit version src;

    postPatch = ''
      			cp ${./package-lock.json} package-lock.json
      		'';

    sourceRoot = "${src}/booklore-ui";
    npmDepsHash = "sha256-9mq/wJ7HMPdsW0C0kaqXXIr8V49cNyPl65zklNc8sZU=";

    buildPhase = ''
      			runHook preBuild
      			
      			npm run build -- --configuration production # idk if this works

      			runHook postBuild
      		'';

    installPhase = ''
      			runHook preInstall

      			mkdir -p $out
      			cp -r ${src}/booklore-ui/dist/booklore/* $out

      			runHook postInstall
      		'';
  };

  api = stdenvNoCC.mkDerivation {
    pname = "booklore-api";
    inherit version src;

    buildInputs = [ pkgs.openjdk21 ];

    nativeBuildInputs = [ pkgs.zip ];

    buildPhase = ''
      			runHook preBuild

      			cd ${src}/booklore-api

      			export JAVA_HOME=${pkgs.openjdk21}/lib/openjdk
      			export PATH="$JAVA_HOME/bin:$PATH"
      			export GRADLE_USER_HOME=$(pwd)/.gradle

      			./gradlew --no-daemon clean bootJar 

      			runHook postBuild
      		'';

    installPhase = ''
      			runHook preInstall
      			
      			mkdir -p $out/lib
      			cp ${src}/booklore-api/build/libs/*.jar $out/lib/
      			cat > $out/run <<'EOF'
      #!/bin/sh
      exec "$JAVA_HOME/bin/java" -jar "$PWD/lib/$(ls lib | head -n1)" "$@"
      EOF
      			chmod +x $out/run

      			runHook postInstall
      		'';
  };

in
{
  inherit ui api;

  meta = with lib; {
    description = "Booklore API Spring Boot application";
    homepage = "https://github.com/booklore-app/booklore";
    license = licenses.gpl3;
  };
}
