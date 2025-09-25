{
  config,
  ...
}: {
  sops.secrets."wg_pub_key" = {};

  networking.firewall.allowedUDPPorts = [ 51821 ];

  systemd.network = {
    enable = true;

    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      
      address = [
        "10.0.0.2/24"
      ];
    };

    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };

      wireguardConfig = {
        ListenPort = 51821;
        PrivateKeyFile = config.sops.secrets."wg_pub_key".path;
        RouteTable = "main";
        FirewallMark = 42;
      };
    };
    # wireguardPeers = [
    #   {
    #     
    #   }
    # ];
  };
}
