{
  imports = [
    # Essentials
    ../services/cloudflared
    ../services/openssh
    ../services/tailscale
    ../services/dnsmasq
    ../services/nginx
    ../system/sops

    # Services
    ../services/nextcloud
    ../services/calibre-server
    ../services/vaultwarden
    # ../services/paperless
    ../services/zipline
    ../services/hedgedoc
    ../services/audiobookshelf
  ];
}
