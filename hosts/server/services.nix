# Self-hosted services.
let
  baseDomain = "224668.xyz";

  sub = d: "${d}.${baseDomain}";
in
{
  imports = [
    # Essentials
    ../../modules/services/nginx
    ../../modules/services/cloudflared
    ../../modules/services/openssh
    ../../modules/services/tailscale
    ../../modules/services/dnsmasq
    ../../modules/system/sops

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

  woof = {
    #
    # Apps
    #
    nextcloud = {
      enable = true;
      domain = sub "cloud";
      domainAliases = [ "cloud.x.home" ];
    };
    vaultwarden = {
      enable = true;
      domain = sub "vault";
      domainAliases = [ "vault.x.home" ];
    };
    zipline = {
      enable = true;
      domain = sub "zip";
      domainAliases = [ "zip.x.home" ];
    };
    calibre-server = {
      enable = true;
      domain = sub "calibre.x.home";
    };
    audiobookshelf = {
      enable = true;
      domain = sub "books";
      domainAliases = [ "books.x.home" ];
    };
    hedgedoc = {
      enable = true;
      domain = sub "note";
      domainAliases = [ "note.x.home" ];
    };
    # uptime-kuma = {
    #   enable = true;
    #   domain = sub "up";
    #   domainAliases = [ "up.x.home" ];
    # };
    authentik = {
      enable = true;
    };
    grafana = {
      enable = true;
      domain = sub "dash";
      domainAliases = [ "dash.x.home" ];
    };
    monitoring = {
      enable = true;
    };
  };
}
