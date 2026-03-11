{
  pkgs,
  config,
  lib,
  ...
}:
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = "cloud.224668.xyz";
    https = false; # don't forget to switch this if not behind cloudflare tunnel
    maxUploadSize = "1G";

    settings = {
      trusted_domains = [ "*" ];

      "memcache.distributed" = "\\OC\\Memcache\\Redis";
      "memcache.locking" = "\\OC\\Memcache\\Redis";

      redis = lib.mkForce {
        host = "10.0.1.3";
        port = 5555;
      };
    };

    caching.apcu = true;
  
    secretFile = "/run/secrets/nextcloud/redisNextcloudPass";

    config = {
      adminuser = "admin";
      adminpassFile = "/run/secrets/nextcloud/adminPass";
      dbtype = "pgsql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      dbpassFile = "/run/secrets/nextcloud/dbPass";
      dbhost = "10.0.1.2:5432";
    };

    extraAppsEnable = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) calendar tasks mail;
    };
  };

  environment.systemPackages = with pkgs; [
    postgresql
  ];

  services.nginx.virtualHosts = {
    "${config.services.nextcloud.hostName}".listen = [
      {
        addr = "0.0.0.0";
        port = 80;
      }
    ];
  };

  services.redis.servers.nextcloud.enable = lib.mkForce false;

  networking = {
    firewall.allowedTCPPorts = [ 80 ];
    useHostResolvConf = lib.mkForce false;
  };
    
  services.resolved.enable = true;
  system.stateVersion = "25.11";
}
