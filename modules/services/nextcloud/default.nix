{
  pkgs,
  config,
  ...
}:
{
  sops.secrets."nextcloud/adminPass" = { };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = "cloud.224668.xyz";
    https = false; # don't forget to switch this if not behind cloudflare tunnel
    maxUploadSize = "1G";

    settings = {
      trusted_domains = [ "*" ];
    };

    caching = {
      redis = true;
      apcu = true;
    };

    configureRedis = true;

    config = {
      adminuser = "admin";
      adminpassFile = config.sops.secrets."nextcloud/adminPass".path;
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

  # services.nginx.virtualHosts = {
  #   "${config.services.nextcloud.hostName}".listen = [
  #     {
  #       addr = "0.0.0.0";
  #       port = 8997;
  #     }
  #   ];
  # };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [
      "nextcloud"
    ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensurePermissions = {
          "nextcloud.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };
}
