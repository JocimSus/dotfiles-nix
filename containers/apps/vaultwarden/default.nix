{
  containers.vaultwarden = {
    autoStart = true;

    privateNetwork = true;
    hostAddress = "10.0.2.1";
    localAddress = "10.0.2.4";

    bindMounts = {
      "/var/lib/vaultwarden" = {
        hostPath = "/var/lib/vaultwarden";
        isReadOnly = false;
      };
      "/var/lib/backups/vaultwarden" = {
        hostPath = "/var/lib/backups/vaultwarden";
        isReadOnly = false;
      };
      "/run/secrets/vaultwardenEnv" = {
        hostPath = "/run/secrets/vaultwardenEnv";
        isReadOnly = true;
      };
    };

    config = import ./vaultwarden.nix;
  };
}
