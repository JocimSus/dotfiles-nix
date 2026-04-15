# Self-hosted services.
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
      domain = "cloud.224668.xyz";
      domainAliases = [ "cloud.x.home" ];
    };
    vaultwarden = {
      enable = true;
      domain = "vault.224668.xyz";
      domainAliases = [ "vault.x.home" ];
    };
    zipline = {
      enable = true;
      domain = "zip.224668.xyz";
      domainAliases = [ "zip.x.home" ];
    };
    calibre-server = {
      enable = true;
      domain = "calibre.x.home";
    };
    audiobookshelf = {
      enable = true;
      domain = "books.224668.xyz";
      domainAliases = [ "books.x.home" ];
    };
    hedgedoc = {
      enable = true;
      domain = "note.224668.xyz";
      domainAliases = [ "note.x.home" ];
    };
    uptime-kuma = {
      enable = true;
      domain = "up.224668.xyz";
      domainAliases = [ "up.x.home" ];
    };
    authentik = {
      enable = true;
    };
    grafana = {
      enable = true;
      domain = "dash.224668.xyz";
      domainAliases = [ "dash.x.home" ];
    };
    monitoring = {
      enable = true;
    };
  };
}
