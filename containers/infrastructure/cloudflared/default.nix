{
  containers.cloudflared = {
    autoStart = true;

    privateNetwork = false;
    hostAddress = "10.0.0.1";
    localAddress = "10.0.0.3";

    bindMounts = {
      "/root/.cloudflared" = {
        hostPath = "/home/jocim-server/.cloudflared";
        isReadOnly = true;
      };
    };  

    config = import ./cloudflared.nix;
  };
}
