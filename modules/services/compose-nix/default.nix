# Courtesy of https://medium.com/@stylishavocado/managing-docker-containers-with-docker-compose-in-nixos-take-2-1153801fb547
# modified to be called for each instance, and not a list of instances.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.compose-nix;
in
{
  options.compose-nix = {
    enable = lib.mkEnableOption "Enable single-instance docker-compose app service";

    instance = lib.mkOption {
      type = lib.types.submodule {
        options = {
          appName = lib.mkOption {
            type = lib.types.str;
            description = "App name for indexing.";
          };

          composeFile = lib.mkOption {
            type = lib.types.path;
            default = ./docker-compose.yaml;
            description = "Path to docker-compose.yaml (default: ./docker-compose.yaml).";
          };
          overrideCompose = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = "Optional path to an override docker-compose YAML file. If set, it will be passed as a second -f argument.";
          };
          sopsSecretFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = "Optional encrypted dotenv secrets file (e.g., secrets.env.enc) managed by sops-nix. If null, no /etc/<instance>/secrets.env will be created or passed to docker compose.";
          };
        };
      };
    };
  };

  config =
    let
      instCfg = cfg.instance;
    in
    lib.mkIf cfg.enable {
      environment.etc =
        let
          composeSrc = instCfg.composeFile;
          overrideEntry = lib.mkIf (instCfg.overrideCompose != null) {
            "${instCfg.appName}/docker-compose.override.yaml".source = instCfg.overrideCompose;
          };
        in
        lib.mkMerge [
          { "${instCfg.appName}/docker-compose.yaml".source = composeSrc; }
          overrideEntry
        ];

      sops.secrets = lib.mkIf (instCfg.sopsSecretFile != null) {
        "${instCfg.appName}-secrets" = {
          sopsFile = instCfg.sopsSecretFile;
          path = "/etc/${instCfg.appName}/.env";
          owner = "root";
          group = "root";
          mode = "0600";
          format = "dotenv";
        };
      };

      systemd.services."compose-${instCfg.appName}" =
        let
          composeFiles =
            "-f /etc/${instCfg.appName}/docker-compose.yaml"
            + (
              if instCfg.overrideCompose != null then
                " -f /etc/${instCfg.appName}/docker-compose.override.yaml"
              else
                ""
            );
          composeCmd = "${pkgs.docker}/bin/docker compose ${composeFiles} " + "up -d";
          composeDownCmd = "${pkgs.docker}/bin/docker compose ${composeFiles} " + "down";
        in
        {
          description = "Docker Compose " + instCfg.appName + " (up on start, down on stop)";
          after = [
            "network-online.target"
            "docker.service"
          ];
          requires = [
            "docker.service"
            "network-online.target"
          ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            WorkingDirectory = "/etc/${instCfg.appName}";
            Type = "oneshot";
            RemainAfterExit = "yes";
            ExecStart = composeCmd;
            ExecStop = composeDownCmd;
            TimeoutStopSec = "120s";
          };
        };

      virtualisation.docker.enable = true;
    };
}
