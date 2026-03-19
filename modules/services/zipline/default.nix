{
  config,
  lib,
  ...
}:
let
  cfg = config.woof.zipline;
in
{
  options.woof.zipline = {
    enable = lib.mkEnableOption "enable zipline service";

    domain = lib.mkOption {
      type = lib.types.str;
      example = "zip.224668.xyz";
      description = "public domain to access";
    };

    domainAliases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "zip.x.home" ];
      description = "additional domains";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8090;
      example = 8090;
    };

    sops = {
      envFile = lib.mkOption {
        type = lib.types.str;
        default = "ziplineEnv";
        example = "ziplineEnv";
        description = "env file for zipline";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.${cfg.sops.envFile} = { };

    services.zipline = {
      enable = true;
      database.createLocally = true;
      environmentFiles = [ config.sops.secrets.${cfg.sops.envFile}.path ];
      settings = {
        CORE_PORT = cfg.port;
        CORE_HOSTNAME = "127.0.0.1";
        DATASOURCE_TYPE = "local";
        FILES_MAX_FILE_SIZE = "200mb";
        CHUNKS_MAX = "60mb";
        CHUNKS_SIZE = "20mb";
        CHUNKS_ENABLED = "true";
      };
    };

    services.nginx.virtualHosts.${cfg.domain} = lib.mkMerge [
      {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          extraConfig = ''
            client_max_body_size 1G;
          '';
        };
      }

      (lib.mkIf (cfg.domainAliases != [ ]) {
        serverAliases = cfg.domainAliases;
      })
    ];
  };
}
