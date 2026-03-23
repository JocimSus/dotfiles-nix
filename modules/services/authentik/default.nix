{
  config,
  lib,
  ...
}:
let
  cfg = config.woof.authentik;
in
{
  imports = [
    ../compose-nix
  ];

  options.woof.authentik = {
    enable = lib.mkEnableOption "enable authentik with docker compose";
  };

  config = lib.mkIf cfg.enable {
    compose-nix = {
      enable = true;

      instance = {
        appName = "authentik";
        composeFile = ./docker-compose.yaml;
        sopsSecretFile = ./authentik.env;
      };
    };
  };
}
