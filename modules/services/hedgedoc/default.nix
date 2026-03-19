{
  config,
  lib,
  ...
}:
let
  cfg = config.woof.hedgedoc;
in
{
  options.woof.hedgedoc = {
    enable = lib.mkEnableOption "enable hedgedoc service";

    domain = lib.mkOption {
      type = lib.types.str;
      example = "note.224668.xyz";
      description = "public domain to access";
    };

    domainAliases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "note.x.home" ];
      description = "additional domains";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8017;
      example = 8017;
    };

    sops = {
      envFile = lib.mkOption {
        type = lib.types.str;
        default = "hedgedocEnv";
        example = "hedgedocEnv";
        description = "env file for hedgedoc";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.${cfg.sops.envFile} = { };

    services.hedgedoc = {
      enable = true;
      environmentFile = config.sops.secrets.${cfg.sops.envFile}.path;
      settings = {
        domain = cfg.domain;
        port = cfg.port;
        host = "127.0.0.1";
        allowEmailRegister = true;
        protocolUseSSL = true;
        allowOrigin = [
          "localhost"
          cfg.domain
        ]
        ++ cfg.domainAliases;
      };
    };

    services.nginx.virtualHosts.${cfg.domain} = lib.mkMerge [
      {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
        };
      }

      (lib.mkIf (cfg.domainAliases != [ ]) {
        serverAliases = cfg.domainAliases;
      })
    ];
  };
}
