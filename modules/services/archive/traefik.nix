{ config
, ...
}: {
  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
          http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
          };
        };

        websecure = {
          address = ":443";
          asDefault = true;
          http.tls.certResolver = "letsencrypt";
        };
      };

      log = {
        level = "DEBUG";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };

      certificatesResolvers.letsencrypt.acme = {
        email = "postmaster@224668.xyz";
        storage = "${config.services.traefik.dataDir}/acme.json";
        httpChallenge.entryPoint = "web";
      };

      api.dashboard = true;
    };


    dynamicConfigOptions = {
      tls = {
        certificates = [
          {
            certFile = "/home/youruser/certs/self.crt";
            keyFile = "/home/youruser/certs/self.key";
          }
        ];
      };
      http = {
        routers = {
          bookie = {
            entryPoints = [ "websecure" ];
            rule = "Host(`bookie.224668.xyz`)";
            service = "bookie";
            tls = { };
          };
          testing = {
            entryPoints = [ "web" ];
            rule = "Host(`test.localhost`)";
            service = "testing-service";
          };
        };

        services = {
          bookie.loadBalancer.servers = [{ url = "http://localhost:8017"; }];
          testing-service.loadBalancer.servers = [{ url = "http://localhost:12345"; }];
        };
      };
    };
  };

  networking.hosts = {
    "127.0.0.1" = [
      "test.localhost"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
