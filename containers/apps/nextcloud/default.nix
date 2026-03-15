{
  containers.cloud = {
    autoStart = true;

    privateNetwork = true;
    hostAddress = "10.0.2.1";
    localAddress = "10.0.2.2";

    bindMounts = {
      "/var/lib/nextcloud" = {
        hostPath = "/var/lib/nextcloud";
        isReadOnly = false;
      };
      "/run/secrets/nextcloud" = {
        hostPath = "/run/secrets/nextcloud";
        isReadOnly = true;
      };
      # "/var/lib/mysql/" = {
      #   hostPath = "/var/lib/mysql";
      #   isReadOnly = false;
      # };
      # "/var/lib/redis-nextcloud/" = {
      #   hostPath = "/var/lib/redis-nextcloud/";
      #   isReadOnly = false;
      # };
    };

    config = import ./nextcloud.nix;
  };
}
