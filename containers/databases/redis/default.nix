{
  containers.redis = {
    autoStart = true;

    privateNetwork = true;
    hostAddress = "10.0.1.1";
    localAddress = "10.0.1.3";

    bindMounts = {
      "/run/secrets/redis" = {
        hostPath = "/run/secrets/redis";
        isReadOnly = true;
      };
    };

    config = import ./redis.nix;
  };
}
