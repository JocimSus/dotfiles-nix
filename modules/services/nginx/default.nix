{
  lib,
  ...
}:
let
  services = {
    cloud = {
      enabledPublic = true;
      enabledLocal = true;
      
      port = 80;
    };
    # calibre = {
    #   enabledLocal = true;
    #   addr = "10.0.2.6";
    #   port = 8085;
    # }; 
    vault = {
      enabledPublic = true;

      port = 8222;
    };
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
      enabledLocal = true;

      port = 8017;
      nginx.extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      '';
    };
    # books = {
    #   enabledPublic = true;
    #   addr = "10.0.2.7";
    #   port = 8000;
    # };
    # yt = {
    #   enabledPublic = true;
    #   port = 5173;
    # };
    # yt-api = {
    #   enabledPublic = true;
    #   port = 3001;
    # };
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

  local = lib.mapAttrs' (name: opts:
    {
      name = "${name}.x.home";
      value = {
        locations."/" = {
          proxyPass = "http://${name}:${toString opts.port}";
        };
      } // (opts.nginx or {});
    }
  ) (lib.filterAttrs (name: opts: builtins.hasAttr "enabledLocal" opts && opts.enabledLocal) services);

  public = lib.mapAttrs' (name: opts:
    {
      name = "${name}.224668.xyz";
      value = {
        locations."/" = {
          proxyPass = "http://${name}:${toString opts.port}";
        };
      } // (opts.nginx or {});
    }
  ) (lib.filterAttrs (name: opts: builtins.hasAttr "enabledPublic" opts && opts.enabledPublic) services);

  manual = {
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
