{
  pkgs,
  lib,
  ...
}:
{
  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    environmentFile = "/run/secrets/vaultwardenEnv";

    domain = "vault.224668.xyz";
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 8222;
      SIGNUPS_ALLOWED = false;
    };
  };

  services.nginx = {
    enable = true;

    virtualHosts."vault.224668.xyz" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8222";
        proxyWebsockets = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    vaultwarden
    sqlite
    pgloader
  ]; 

  networking = {
    firewall.allowedTCPPorts = [ 80 ];
    useHostResolvConf = lib.mkForce false;
  };

  services.resolved.enable = true;
  system.stateVersion = "25.11";
}
