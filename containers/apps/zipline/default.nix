{
  containers.zip = {
    autoStart = true;

    privateNetwork = true;
    hostAddress = "10.0.2.1";
    localAddress = "10.0.2.3";

    bindMounts = {
      "/var/lib/zipline" = {
        hostPath = "/var/lib/zipline";
        isReadOnly = false;
      };
      "/var/lib/private/zipline" = {
        hostPath = "/var/lib/private/zipline";
        isReadOnly = false;
      };
      "/run/secrets/ziplineEnv" = {
        hostPath = "/run/secrets/ziplineEnv";
        isReadOnly = true;
      };
    };

    config = import ./zipline.nix;
  };
}
