{
  imports = [
    # Essentials
    ./cloudflared.nix
    ./openssh.nix
    ./tailscale.nix

    # Fun
    # ./nginx.nix
    # ./traefik.nix
    # ./mailserver.nix
    ./radicale.nix
    ./calibre-server.nix
    ./vaultwarden.nix
    ./pngx.nix
    ./zipline.nix
    ./hedgedoc.nix
    ./audiobookshelf.nix
  ];
}
