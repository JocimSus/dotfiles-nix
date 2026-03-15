{
  containers.note = {
    autoStart = true;

    privateNetwork = true;
    hostAddress = "10.0.2.1";
    localAddress = "10.0.2.5";

    bindMounts = {
      "/var/lib/hedgedoc" = {
        hostPath = "/var/lib/hedgedoc";
        isReadOnly = false;
      };
      "/run/secrets/hedgedocEnv" = {
        hostPath = "/run/secrets/hedgedocEnv";
        isReadOnly = true;
      };
    };

    config = import ./hedgedoc.nix;
  };
}
