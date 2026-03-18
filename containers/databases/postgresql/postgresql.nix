{
  lib,
  ...
}:
{
  services.postgresql = {
    enable = true;
    enableTCPIP = true;

  authentication = lib.mkOverride 10 ''
    #type database user address auth-method
    local all all trust
    host  nextcloud nextcloud 10.0.0.0/8 scram-sha-256
    host  vaultwarden vaultwarden 10.0.0.0/8 scram-sha-256
    host  zipline zipline 10.0.0.0/8 scram-sha-256
    host  hedgedoc hedgedoc 10.0.0.0/8 scram-sha-256
  '';

    ensureDatabases = [
      "nextcloud"
      "vaultwarden"
      "zipline"
      "hedgedoc"
    ];

    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
        ensureClauses = {
          login = true;
        };
      }
      {
        name = "vaultwarden";
        ensureDBOwnership = true;
        ensureClauses = {
          login = true;
        };
      }
      {
        name = "zipline";
        ensureDBOwnership = true;
        ensureClauses = {
          login = true;
        };
      }
      {
        name = "hedgedoc";
        ensureDBOwnership = true;
        ensureClauses = {
          login = true;
        };
      }
    ];
  };

  networking = {
    firewall.allowedTCPPorts = [ 5432 ];
    useHostResolvConf = lib.mkForce false;
  };

  services.resolved.enable = true;
  system.stateVersion = "25.11";
}
