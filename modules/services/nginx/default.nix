{
  config,
  lib,
  ...
}:
let
  services = {
    # cloud = {
    #   enabledLocal = true;
    #   enabledPublic = true;
    #   # port = 8997;
    #   alias = "cloud.x.home";
    # };
    calibre = {
      enabledLocal = true;
      port = 8085;
    }; 
    vault = {
      enabledPublic = true;
      port = 8222;
    };
    # paperless = 28981;
    zip = {
      enabledLocal = true;
      enabledPublic = true;
      port = 8090;
      nginx.extraConfig = ''
        client_max_body_size 200M;
      '';
    };
    note = {
      enabledPublic = true;
      port = 8017;
    };
    books = {
      enabledPublic = true;
      port = 8000;
    };
    yt = {
      enabledPublic = true;
      port = 5173;
    };
    yt-api = {
      enabledPublic = true;
      port = 3001;
    };
    # dev-tokogo-api = {
    #   port = 3334;
    # };
    # forms = {
    #   port = 3000;
    # };
    # forms-api = {
    #   port = 4000;
    # };
  };

  hostAddr = "127.0.0.1";

  local = lib.mapAttrs' (name: opts:
    {
      name = "${name}.x.home";
      value = {
        locations."/" = {
          proxyPass = "http://${hostAddr}:${toString opts.port}";
        };
      } // (opts.nginx or {});
    }
  ) (lib.filterAttrs (name: opts: builtins.hasAttr "enabledLocal" opts && opts.enabledLocal) services);

  public = lib.mapAttrs' (name: opts:
    {
      name = "${name}.224668.xyz";
      value = {
        locations."/" = {
          proxyPass = "http://${hostAddr}:${toString opts.port}";
        };
      } // (opts.nginx or {});
    }
  ) (lib.filterAttrs (name: opts: builtins.hasAttr "enabledPublic" opts && opts.enabledPublic) services);

  manual = {
    # "${config.services.nextcloud.hostName}".listen = [
    #   {
    #     addr = "0.0.0.0";
    #     port = 8997;
    #   }
    # ];

    # "${config.services.nextcloud.hostName}".serverAliases = [ "cloud.x.home" ];
    "cloud.224668.xyz".serverAliases = [ "cloud.x.home" ];

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
