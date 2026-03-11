{
  pkgs,
  lib,
  ...
}:
{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "648572fb-8580-447d-9c68-4bf0380ab7d8" = {
        credentialsFile = "/root/.cloudflared/648572fb-8580-447d-9c68-4bf0380ab7d8.json";
        ingress = {
          "*.224668.xyz" = {
              service = "http://10.0.0.2:80";
          };
        };
        default = "http_status:404";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    cloudflared
  ];

  networking = {
    firewall.allowedTCPPorts = [ 80 ];
    useHostResolvConf = lib.mkForce false;
  };

  services.resolved.enable = true;
  system.stateVersion = "25.11";
}
