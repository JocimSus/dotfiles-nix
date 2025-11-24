{
  imports = [
    # Essentials
    ../services/cloudflared
    ../services/openssh
    ../services/tailscale
    ../system/sops

    # Services
    ../services/nextcloud
    ../services/calibre-server
    ../services/vaultwarden
    ../services/paperless
    ../services/zipline
    ../services/hedgedoc
    ../services/audiobookshelf
  ];
}
