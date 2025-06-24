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
    ./pngx.nix
    ./zipline.nix
  ];
}
