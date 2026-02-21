{
  config,
  lib,
  ...
}:
let
  services = {
    # cloud = 8997; # let nextcloud manage itself
    calibre = {
      port = 8085;
    }; 
    vault = {
      port = 8222;
    };
    # paperless = 28981;
    zip = {
      port = 8090;
      nginx.extraConfig = ''
        client_max_body_size 200M;
      '';
    };
    note = {
      port = 8017;
    };
    books = {
      port = 8000;
    };
    yt = {
      port = 5173;
    };
    yt-api = {
      port = 3001;
    };
    dev-tokogo-api = {
      port = 3334;
    };
  };

  local = lib.mapAttrs' (name: opts: {
    name = "${name}.x.home";
    value = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString opts.port}";
      };
    } // (opts.nginx or {});
  }) services;

  public = lib.mapAttrs' (name: opts: {
    name = "${name}.224668.xyz";
    value = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString opts.port}";
      };
    } // (opts.nginx or {});
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
