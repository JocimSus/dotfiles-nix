{
  imports = [
    # Essentials
    ./homepage-dashboard.nix
    ./cloudflared.nix
    ./openssh.nix
    ./tailscale.nix
    
    # Fun
    #./nextcloud.nix
    #./grafana.nix
    ./microbin.nix
    ./calibre-server.nix
    #./calibre-web.nix
  ];
}
