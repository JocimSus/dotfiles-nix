{ lib, config, pkgs, ... }:

let
  cfg = config.services.my.wireguard;
in
{
  options.services.my.wireguard = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    address = lib.mkOption {
      type = lib.types.str;
      description = "WireGuard interface address for wg0.";
    };

    listenPort = lib.mkOption {
      type = lib.types.int;
      default = 51821;
      description = "WireGuard ListenPort for wg0.";
    };

    firewallUDPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [ 51821 ];
      description = "UDP ports to allow through the firewall.";
    };

    privateKeySecretName = lib.mkOption {
      type = lib.types.str;
      default = "wg_private_key";
      description = "Name of the sops secret containing WireGuard private key.";
    };

    peers = lib.mkOption {
      type = lib.types.listOf (lib.types.attrsOf lib.types.any);
      default = [];
      description = ''
        List of WireGuard peers. Each peer is an attribute set, for example:
        { PublicKey = "..."; AllowedIPs = [ "10.0.0.1/32" ]; Endpoint = "1.2.3.4:51821"; }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."${cfg.privateKeySecretName}" = {
      mode = "640";
      owner = "root";
      group = "systemd-network";
    };

    networking.firewall.allowedUDPPorts = lib.unique ((config.networking.firewall.allowedUDPPorts or []) ++ cfg.firewallUDPPorts);

    networking.useNetworkd = true;

    systemd.network.enable = true;

    systemd.network.networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = [ cfg.address ];
    };

    systemd.network.netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };

      wireguardConfig = {
        ListenPort = cfg.listenPort;
        PrivateKeyFile = config.sops.secrets."${cfg.privateKeySecretName}".path;
        RouteTable = "main";
        FirewallMark = 42;
      };

      wireguardPeers = cfg.peers;
    };
  };
}
