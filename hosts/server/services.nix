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
  ];

  woof.network.basePublicDomain = "jocimsus.tech";
  woof.network.baseLocalDomain = "home";

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

    #
    # Monitoring
    #
    monitoring.enable = true;
  };
}
