{
  imports = [
    # Essentials
    ./cloudflared.nix
    ./openssh.nix
    ./tailscale.nix

    # Fun
    ./mailserver.nix
    ./nextcloud.nix
    ./calibre-server.nix
    ./vaultwarden.nix
    ./pngx.nix
    ./zipline.nix
    ./hedgedoc.nix
    ./audiobookshelf.nix
  ];
}
