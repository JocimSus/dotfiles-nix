{
  pkgs,
  config,
  ...
}: {
<<<<<<< HEAD
  environment.etc."nextcloud-admin-pass".text = "this shit can't get worse";
=======
  sops.secrets."nextcloud/adminUser" = {};
  sops.secrets."nextcloud/adminPass" = {} ;

>>>>>>> 02e0f97 (secured)
  services.nextcloud = {
    enable = true;
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
