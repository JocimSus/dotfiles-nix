{
  lib,
  ...
}:
{
  services.redis = {
    servers = {
      "nextcloud" = {
        enable = true;

        bind = "0.0.0.0";
        port = 5555;
        requirePassFile = "/run/secrets/redis/dbPass";
      };
    };
  };

  networking = {
    firewall.allowedTCPPorts = [ 5555 ];
    useHostResolvConf = lib.mkForce false;
  };

  services.resolved.enable = true;
  system.stateVersion = "25.11";
}
