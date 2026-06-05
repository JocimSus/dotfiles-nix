{
  config,
  lib,
  ...
}:
let
  cfg = config.woof.calibre-server;
in
{
  options.woof.calibre-server = {
    enable = lib.mkEnableOption "enable calibre-server service";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "calibre.${config.woof.network.basePublicDomain}";
      example = "calibre.${config.woof.network.basePublicDomain}";
      description = "public domain to access";
    };

    domainAliases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "calibre.${config.woof.network.baseLocalDomain}" ];
      example = [ "calibre.${config.woof.network.baseLocalDomain}" ];
      description = "additional domains";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8085;
      example = 8085;
    };
  };

  config = lib.mkIf cfg.enable {
    services.calibre-server = {
      enable = true;
      port = cfg.port;
      user = "calibre-server";
      group = "media";
      libraries = [ "/media/books" ];
      auth = {
        enable = true;
        mode = "basic";
        userDb = "/var/lib/calibre-server/users.sqlite";
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
