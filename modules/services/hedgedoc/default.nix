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
        # port = cfg.port;
        # host = "127.0.0.1";
        path = "/run/hedgedoc/hedgedoc.sock";
        allowEmailRegister = false;
        protocolUseSSL = true;
        allowOrigin = [
          "localhost"
          cfg.domain
        ]
        ++ cfg.domainAliases;
      };
    };

    users = {
      groups."hedgedoc" = { };
      users = {
        nginx = {
          extraGroups = [ "hedgedoc" ];
        };
        "hedgedoc" = {
          description = "HedgeDoc service user";
          group = "hedgedoc";
          isSystemUser = true;
        };
      };
    };

    services.nginx = {
      upstreams.hedgedoc.servers."unix:/run/hedgedoc/hedgedoc.sock" = { };
      virtualHosts.${cfg.domain} = lib.mkMerge [
        {
          locations."/" = {
            proxyPass = "http://hedgedoc";

            extraConfig = ''
              proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;
              proxy_set_header X-Forwarded-Host $host;
            '';
          };
          locations."/socket.io/" = {
            proxyPass = "http://hedgedoc";
            proxyWebsockets = true;

            extraConfig = ''
              proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;
              proxy_set_header X-Forwarded-Host $host;
            '';
          };
        }

        (lib.mkIf (cfg.domainAliases != [ ]) {
          serverAliases = cfg.domainAliases;
        })
      ];
    };
  };
}
