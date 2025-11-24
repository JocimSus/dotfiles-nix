{ config
, ...
}: {
  sops.secrets."hedgedocEnv" = { };

  services.hedgedoc = {
    enable = true;
    environmentFile = config.sops.secrets."hedgedocEnv".path;
    settings = {
      domain = "note.224668.xyz";
      port = 8017;
      host = "127.0.0.1";
      allowEmailRegister = true;
      protocolUseSSL = true;
      allowOrigin = [
        "localhost"
        "note.224668.xyz"
      ];
    };
  };
}
