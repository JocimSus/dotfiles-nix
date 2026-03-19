{
  config,
  lib,
  ...
}:
let
  cfg = config.woof.audiobookshelf;
in
{
  options.woof.audiobookshelf = {
    enable = lib.mkEnableOption "enable audiobookshelf service";

    domain = lib.mkOption {
      type = lib.types.str;
      example = "books.224668.xyz";
      description = "public domain to access";
    };

    domainAliases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "books.x.home" ];
      description = "additional domains";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      example = 8000;
    };
  };

  config = lib.mkIf cfg.enable {
    services.audiobookshelf = {
      enable = true;
      host = "127.0.0.1";
      port = cfg.port;
    };

    services.nginx.virtualHosts.${cfg.domain} = lib.mkMerge [
      {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
        };
      }

      (lib.mkIf (cfg.domainAliases != [ ]) {
        serverAliases = cfg.domainAliases;
      })
    ];
  };
}
