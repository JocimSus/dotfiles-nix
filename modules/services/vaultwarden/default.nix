{
  config,
  ...
}:
{
  sops.secrets."vaultwardenEnv" = { };

  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    environmentFile = config.sops.secrets."vaultwardenEnv".path;
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      DOMAIN = "https://vault.224668.xyz";
      SIGNUPS_ALLOWED = false;
    };
  };
}
