{
  pkgs,
  config,
  ...
}: {
  sops.secrets."nextcloud/adminUser" = {};
  sops.secrets."nextcloud/adminPass" = {} ;

  services.nextcloud = {
    enable = false;
    package = pkgs.nextcloud31;
    hostName = "cloud.224668.xyz";
    https = true;
    maxUploadSize = "1G";
    caching = {
      redis = true;
#      apcu = true;
    };
    configureRedis = true;
    config = {
      adminuser = config.sops.secrets."nextcloud/adminUser".path;
      adminpassFile = config.sops.secrets."nextcloud/adminPass".path;
      dbtype = "sqlite";
    };
  };
}
