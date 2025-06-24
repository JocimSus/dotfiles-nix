{
  config,
  ...
}: {
  sops.secrets."microbinEnv" = {};

  services.microbin = {
    enable = true;
    passwordFile = config.sops.secrets."microbinEnv".path;
    settings = {
      MICROBIN_PORT = 8084;
<<<<<<< HEAD
      MICROBIN_ADMIN_USERNAME = "jocim-server";
      MICROBIN_ADMIN_PASSWORD = "idiot says leak password on github";
=======
>>>>>>> 8cd75d6 (secured)
      MICROBIN_BIND = "0.0.0.0";
      MICROBIN_ETERNAL_PASTA = true;
      MICROBIN_PRIVATE = true;
      #MICROBIN_READONLY = true;
<<<<<<< HEAD
      #MICROBIN_UPLOADER_PASSWORD = "keledai tidak jatuh ke lubang yang sama headass";
=======
>>>>>>> 8cd75d6 (secured)
      MICROBIN_ENCRYPTION_CLIENT_SIDE = true;
      MICROBIN_ENCRYPTION_SERVER_SIDE = true;
      MICROBIN_HASH_IDS = true;
      MICROBIN_DISABLE_TELEMETRY = true;
    };
  };
}
