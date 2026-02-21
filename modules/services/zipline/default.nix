{
  config,
  ...
}:
{
  sops.secrets."ziplineEnv" = { };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "zipline" ];
    ensureUsers = [
      {
        name = "postgres";
      }
    ];
  };

  services.zipline = {
    enable = true;
    environmentFiles = [ config.sops.secrets."ziplineEnv".path ];
    settings = {
      CORE_PORT = 8090;
      CORE_HOSTNAME = "0.0.0.0";
      DATASOURCE_TYPE = "local";
      FILES_MAX_FILE_SIZE = "200mb";
      CHUNKS_MAX = "60mb";
      CHUNKS_SIZE = "20mb";
      CHUNKS_ENABLED = "true";
    };
  };
}
