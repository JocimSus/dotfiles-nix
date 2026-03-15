{
  lib,
  ...
}:
{
  services.hedgedoc = {
    enable = true;
    environmentFile = "/run/secrets/hedgedocEnv";
    settings = {
      domain = "note.224668.xyz";
      port = 8017;
      host = "0.0.0.0";
      allowEmailRegister = true;
      protocolUseSSL = true;
      # allowOrigin = [
      #   "localhost"
      #   "note.224668.xyz"
      # ];
    };
  };

  networking = {
    firewall.allowedTCPPorts = [ 8017 ];
    useHostResolvConf = lib.mkForce false;
  };

  services.resolved.enable = true;
  system.stateVersion = "25.11";
}
