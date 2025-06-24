{
  imports = [
    # Essentials
    ./cloudflared.nix
    ./openssh.nix
    ./tailscale.nix

    # Fun
    ./nextcloud.nix
    ./calibre-server.nix
    ./vaultwarden.nix
    ./code-server.nix
    ./pngx.nix
    ./zipline.nix
  ];
}
