{
    imports = [
      inputs.sops-nix.nixosModules.sops

      # Essentials
      ../services/cloudflared
      ../services/openssh
      ../services/tailscale
      ../services/wireguard

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