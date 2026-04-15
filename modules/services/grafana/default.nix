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
      example = "dash.224668.xyz";
      description = "public domain to access";
    };

    domainAliases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "dash.x.home" ];
      description = "additional domains";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8083;
      example = 8083;
    };
  };

  config = lib.mkIf cfg.enable {
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
