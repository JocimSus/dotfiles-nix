{
  config,
  lib,
  ...
}:
let
  cfg = config.woof.grafana;
in
{
  options.woof.grafana = {
    enable = lib.mkEnableOption "enable grafana service";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "dash.${config.woof.network.basePublicDomain}";
      example = "dash.${config.woof.network.basePublicDomain}";
      description = "public domain to access";
    };

    domainAliases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "dash.${config.woof.network.baseLocalDomain}" ];
      example = [ "dash.${config.woof.network.baseLocalDomain}" ];
      description = "additional domains";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8083;
      example = 8083;
    };

    sops = {
      secretKey = lib.mkOption {
        type = lib.types.str;
        default = "grafana/secretKey";
        description = "sops key location for signing grafana secrets";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.${cfg.sops.secretKey} = {
      owner = config.services.grafana.users.users.grafana;
      group = config.services.grafana.users.groups.grafana;
    };

    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = cfg.port;
          enforce_domain = true;
          enable_gzip = true;
          domain = cfg.domain;
        };

        security.secret_key = "$__file{/run/secrets/grafana/secretKey}";
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
