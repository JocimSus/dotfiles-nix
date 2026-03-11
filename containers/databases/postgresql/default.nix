{
  containers.postgresql = {
    autoStart = true;

    privateNetwork = true;
    hostAddress = "10.0.1.1";
    localAddress = "10.0.1.2";

    bindMounts = {
      "/var/lib/postgresql" = {
        hostPath = "/var/lib/postgresql/";
        isReadOnly = false;
      };
    };

    config = import ./postgresql.nix;
  };
}
