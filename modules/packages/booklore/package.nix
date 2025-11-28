{
	stdenvNoCC,
	lib,
	pkgs,

	fetchFromGitHub,
}: 
stdenvNoCC.mkDerivation (finalAttrs: {
	pname = "booklore";
	version = "1.12.0";

	src = fetchFromGitHub {
		owner = "booklore-app";
    repo = "booklore";
    rev = "v${finalAttrs.version}";
    hash = lib.fakeHash;
	};

	nativeBuildInputs = [
		pkgs.nodejs
		pkgs.openjdk
		pkgs.gradle
	];
	
	buildPhase = ''
		cd booklore-ui
		npm ci
		npm run build

		cd ../booklore-api
		./gradlew clean bootJar
	'';

	installPhase = ''
		runHook preInstall

		mkdir -p $out/app

		cp booklore-api/build/libs/*.jar $out/app/booklore.jar

		cp -r ../booklore-ui/dist $out/app/ui

		mkdir -p $out/bin
		cat > $out/bin/booklore <<EOF
		#!/usr/bin/env bash
		exec ${pkgs.openjdk}/bin/java -jar $out/app/booklore.jar \
			--spring.web.resources.static-locations=file:$out/app/ui/
		EOF
		chmod +x $out/bin/booklore

		runHook postInstall
	'';

  meta = with lib; {
    description = "BookLore is a self-hosted web app for organizing and managing your personal book collection.";
    homepage = "https://github.com/booklore-app/booklore";
    license = licenses.gpl3;
  };
})
