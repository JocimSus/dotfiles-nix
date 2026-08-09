{
  config,
  lib,
  ...
}:
let
  cfg = config.woof.minio;
in
{
  options.woof.minio = {
    enable = lib.mkEnableOption "enable minio service";

    sops = {
      rootCredentialsFile = lib.mkOption {
        type = lib.types.str;
        default = "minio";
        example = "minio";
        description = "sops key for minio's root credentials";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.${cfg.sops.rootCredentialsFile} = { };

    services.minio = {
      enable = true;

      consoleAddress = ":9099";
      listenAddress = ":9100";
      region = "ap-southeast-1";

      rootCredentialsFile = config.sops.secrets.${cfg.sops.rootCredentialsFile}.path;
    };
  };
}
