{
  config,
  lib,
  ...
}:
let
  cfg = config.woof.uptime-kuma;
in
{
  options.woof.uptime-kuma = {
    enable = lib.mkEnableOption "enable uptime-kuma service";

    domain = lib.mkOption {
      type = lib.types.str;
      example = "up.224668.xyz";
      description = "public domain to access";
    };

    domainAliases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "up.x.home" ];
      description = "additional domains";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8888;
    };
  };

  config = lib.mkIf cfg.enable {
    services.uptime-kuma = {
      enable = true;
      appriseSupport = true;

      settings = {
        PORT = toString cfg.port;
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
