{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.woof.nextcloud;
in
{
  options.woof.nextcloud = {
    enable = lib.mkEnableOption "enable nextcloud service";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "cloud.${config.woof.network.basePublicDomain}";
      example = "cloud.${config.woof.network.basePublicDomain}";
      description = "public domain to access";
    };

    domainAliases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "cloud.${config.woof.network.baseLocalDomain}" ];
      example = [ "cloud.${config.woof.network.baseLocalDomain}" ];
      description = "additional domains";
    };

    sops = {
      adminPassFile = lib.mkOption {
        type = lib.types.str;
        default = "nextcloud/adminPass";
        example = "nextcloud/adminPass";
        description = "sops key for nextcloud's admin password";
      };
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nextcloud33;
      example = lib.literalExpression "pkgs.nextcloud32";
      description = "nextcloud package to use";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.${cfg.sops.adminPassFile} = { };

    services.nextcloud = {
      enable = true;
      package = cfg.package;
      hostName = cfg.domain;
      https = true;
      maxUploadSize = "1G";

      settings = {
        trusted_domains = [ "*" ];
      };

      caching = {
        redis = true;
        apcu = true;
      };

      configureRedis = true;
      database.createLocally = true;

      config = {
        adminuser = "admin";
        adminpassFile = config.sops.secrets.${cfg.sops.adminPassFile}.path;
        dbtype = "pgsql";
      };

      extraAppsEnable = true;
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) calendar tasks mail;
      };
    };

    services.nginx.virtualHosts.${config.services.nextcloud.hostName} = lib.mkMerge [
      (lib.mkIf (cfg.domainAliases != [ ]) {
        serverAliases = cfg.domainAliases;
      })
    ];
  };
}
