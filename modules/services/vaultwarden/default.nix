{
  config,
  lib,
  ...
}:
let
  cfg = config.woof.vaultwarden;
in
{
  options.woof.vaultwarden = {
    enable = lib.mkEnableOption "enable vaultwarden service";

    domain = lib.mkOption {
      type = lib.types.str;
      example = "vault.224668.xyz";
      description = "public domain to access";
    };

    domainAliases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "vault.x.home" ];
      description = "additional domains";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8222;
      example = 8222;
    };

    sops = {
      envFile = lib.mkOption {
        type = lib.types.str;
        default = "vaultwardenEnv";
        example = "vaultwardenEnv";
        description = "env file for vaultwarden";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.${cfg.sops.envFile} = { };

    services.vaultwarden = {
      enable = true;
      configurePostgres = true;
      dbBackend = "postgresql";
      environmentFile = config.sops.secrets.${cfg.sops.envFile}.path;
      domain = cfg.domain;
      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = cfg.port;
        SIGNUPS_ALLOWED = false;
      };
    };

    services.nginx.virtualHosts.${cfg.domain} = lib.mkMerge [
      {
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.port}";
          };

          "/notifications/hub" = {
            proxyPass = "http://127.0.0.1:${toString cfg.port}";
            proxyWebsockets = true;
          };

          "/notifications/anonymous-hub" = {
            proxyPass = "http://127.0.0.1:${toString cfg.port}";
            proxyWebsockets = true;
          };
        };
      }

      (lib.mkIf (cfg.domainAliases != [ ]) {
        serverAliases = cfg.domainAliases;
      })
    ];
  };
}
