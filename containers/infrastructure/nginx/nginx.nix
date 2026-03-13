{
  lib,
  ...
}:
let
  services = {
    cloud = {
      enabledPublic = true;
      addr = "10.0.2.2";
    };
    # calibre = {
    #   enabledLocal = true;
    #   addr = "10.0.2.6";
    #   port = 8085;
    # }; 
    vault = {
      enabledPublic = true;
      addr = "10.0.2.4";
      port = 8222;
    };
    # # paperless = 28981;
    # zip = {
    #   enabledLocal = true;
    #   enabledPublic = true;
    #   addr = "10.0.2.3";
    #   port = 8090;
    #   nginx.extraConfig = ''
    #     client_max_body_size 200M;
    #   '';
    # };
    # note = {
    #   enabledPublic = true;
    #   addr = "10.0.2.5";
    #   port = 8017;
    # };
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
          proxyPass = "http://${opts.addr}";
        };
      } // (opts.nginx or {});
    }
  ) (lib.filterAttrs (name: opts: builtins.hasAttr "enabledLocal" opts && opts.enabledLocal) services);

  public = lib.mapAttrs' (name: opts:
    {
      name = "${name}.224668.xyz";
      value = {
        locations."/" = {
          proxyPass = "http://${opts.addr}";
        };
      } // (opts.nginx or {});
    }
  ) (lib.filterAttrs (name: opts: builtins.hasAttr "enabledPublic" opts && opts.enabledPublic) services);

  manual = {
    # "cloud.224668.xyz".serverAliases = [ "cloud.x.home" ];

    # "cloud.224668.xyz" = {
    #   locations."/" = {
    #     proxyPass = "http://10.0.2.2:80";
    #   };
    # };

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
      
  networking = {
    firewall.allowedTCPPorts = [ 80 443 ];
    useHostResolvConf = lib.mkForce false;
  };
    
  services.resolved.enable = true;
  system.stateVersion = "25.11";
}
