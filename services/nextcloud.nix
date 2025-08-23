{
  pkgs,
  config,
  ...
}: {
  sops.secrets."nextcloud/adminPass" = {} ;

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = "cloud.224668.xyz";
    https = true;
    maxUploadSize = "1G";

    caching = {
      redis = true;
      apcu = true;
    };

    configureRedis = true;

    config = {
      adminuser = "admin";
      adminpassFile = config.sops.secrets."nextcloud/adminPass".path;
      dbtype = "mysql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      dbhost = "localhost";
    };

    extraAppsEnable = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) calendar; 
    };
  };

  services.nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [ { addr = "127.0.0.1"; port = 8997; } ];

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
