{
	booklore,
	...
}: {
	imports = [
		"${booklore}/nixos/modules/services/web-apps/booklore.nix"
	];

	sops.secrets.booklore_db_passwd = {
    owner = "booklore";
  };

	services.booklore = {
    enable = true;
    host = "0.0.0.0";
    package = booklore.legacyPackages.x86_64-linux.booklore;
    secretFiles = {
      DATABASE_PASSWORD = "/run/secrets/booklore_db_passwd";
    };
  };
}
