{
  lib,
  ...
}:
{
  services.zipline = {
    enable = true;
    environmentFiles = [ "/run/secrets/ziplineEnv" ];

    settings = {
      CORE_PORT = 8090;
      CORE_HOSTNAME = "0.0.0.0";
      DATASOURCE_TYPE = "local";
      FILES_MAX_FILE_SIZE = "200mb";
      CHUNKS_MAX = "60mb";
      CHUNKS_SIZE = "20mb";
      CHUNKS_ENABLED = "true";
    };
  };

  systemd.services.zipline.serviceConfig.StateDirectory = lib.mkForce null;
  systemd.services.zipline.serviceConfig.DynamicUser = lib.mkForce false;
  systemd.services.zipline.serviceConfig.User = "zipline";
  systemd.services.zipline.serviceConfig.Group = "zipline";
  systemd.services.zipline.serviceConfig.ReadWritePaths = [ "/var/lib/zipline" "/tmp" ];

  users.users.zipline = {
    isSystemUser = true;
    group = "zipline";
  };

  users.groups.zipline = {};

  networking = {
    firewall.allowedTCPPorts = [ 8090 ];
    useHostResolvConf = lib.mkForce false;
  };

  services.resolved.enable = true;
  system.stateVersion = "25.11";
}
