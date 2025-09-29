{
  config,
  ...
}: {
  sops.secrets."wg_private_key" = {
    mode = "640";
    owner = "root";
    group = "systemd-network";
  };

  networking.firewall.allowedUDPPorts = [ 51821 ];
  networking.useNetworkd = true;

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
        PrivateKeyFile = config.sops.secrets."wg_private_key".path;
        RouteTable = "main";
        FirewallMark = 42;
      };
      wireguardPeers = [
        {
          PublicKey = "WbMwTLtCsxl8aiyZne1ge/eDkPZoa01NGiqy9b9QeQE=";
          AllowedIPs = [
            "10.0.0.1/32"
          ];
          Endpoint = "192.168.1.7:51821";
        }
      ];
    };
  };
}
