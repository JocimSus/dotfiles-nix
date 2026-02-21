{
  config,
  lib,
  ...
}:
let
  services = {
    # cloud = 8997; # let nextcloud manage itself
    calibre = 8085; 
    vault = 8222;
    paperless = 28981;
    zip = 8090;
    note = 8017;
    books = 8000;
    yt = 5173;
    yt-api = 3001;
    dev-tokogo-api = 3334;
  };

  local = lib.mapAttrs' (name: port: {
    name = "${name}.x.home";
    value = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
      };
    };
  }) services;

  public = lib.mapAttrs' (name: port: {
    name = "${name}.224668.xyz";
    value = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
      };
    };
  }) services;

  manual = {
    # "${config.services.nextcloud.hostName}".listen = [
    #   {
    #     addr = "0.0.0.0";
    #     port = 8997;
    #   }
    # ];

    "${config.services.nextcloud.hostName}".serverAliases = [ "cloud.x.home" ];

    "*.x.home" = {
      locations."/" = {
        return = "404";
      };
    };

    "*.224668.xyz" = {
      locations."/" = {
        return = "404";
      };
    };
  };
in {
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = local 
      // public 
      // manual;
  };
}
