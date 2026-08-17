# Self-hosted services.
{
  imports = [
    ../../modules/services/network # adds domain helpers

    # Essentials
    ../../modules/services/nginx
    ../../modules/services/cloudflared
    ../../modules/services/openssh
    ../../modules/services/tailscale
    # ../../modules/services/dnsmasq
    ../../modules/services/pihole
    ../../modules/services/printing
    ../../modules/system/sops

    # ACME
    ../../modules/services/acme

    # Services
    ../../modules/services/nextcloud
    ../../modules/services/calibre-server
    ../../modules/services/vaultwarden
    ../../modules/services/zipline
    ../../modules/services/hedgedoc
    ../../modules/services/audiobookshelf
    ../../modules/services/uptime-kuma
    ../../modules/services/authentik
    ../../modules/services/grafana
    ../../modules/services/monitoring
    ../../modules/services/minio
  ];

  woof.network.basePublicDomain = "jocimsus.tech";
  woof.network.baseLocalDomain = "home";

  services.nginx.virtualHosts."fisiomate-api.jocimsus.tech".locations."/" = {
    proxyPass = "http://127.0.0.1:8857";
    proxyWebsockets = true;
    extraConfig = ''
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
    '';
  };

  woof = {
    #
    # Apps
    #
    nextcloud.enable = true;
    vaultwarden.enable = true;
    zipline.enable = true;
    calibre-server = {
      enable = true;
      domain = "";
    };
    audiobookshelf.enable = true;
    hedgedoc.enable = true;
    # uptime-kuma.enable = true;
    # authentik.enable = true;
    grafana.enable = true;
    pihole.enable = true;
    minio.enable = true;

    #
    # Monitoring
    #
    monitoring.enable = true;
  };
}
