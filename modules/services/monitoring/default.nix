{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.woof.monitoring;
in
{
  options.woof.monitoring = {
    enable = lib.mkEnableOption "enable monitoring services";
  };

  config = lib.mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      port = 9090;
      globalConfig.scrape_interval = "10s";
      scrapeConfigs = [
        {
          job_name = "woof";
          static_configs = [
            {
              targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
            }
          ];
        }

        {
          job_name = "cadvisor";
          static_configs = [
            {
              targets = [ "localhost:${toString config.services.cadvisor.port}" ];
            }
          ];
        }

        {
          job_name = "blackbox-https";
          metrics_path = "/probe";
          params.module = [ "http_2xx" ];

          scrape_interval = "1m";
          scrape_timeout = "45s"; # dont forget to change the exporter settings too

          static_configs = [
            {
              targets =
                let
                  toDomain = v: "https://${v}.224668.xyz";
                in
                builtins.map toDomain [
                  "cloud"
                  "zip"
                  "vault"
                  "books"
                  "note"
                ];
            }
          ];

          relabel_configs = [
            {
              source_labels = [ "__address__" ];
              target_label = "__param_target";
            }
            {
              source_labels = [ "__param_target" ];
              target_label = "instance";
            }
            {
              target_label = "__address__";
              replacement = "localhost:9115";
            }
          ];
        }
      ];

      exporters = {
        node = {
          enable = true;
          port = 9001;
          enabledCollectors = [
            "ethtool"
            "softirqs"
            "systemd"
            "tcpstat"
            "wifi"
            "processes"
          ];

          extraFlags = [
            "--collector.ntp.protocol-version=4"
            "--no-collector.mdadm"
          ];
        };

        blackbox = {
          enable = true;
          port = 9115;

          configFile = pkgs.writeText "blackbox.yml" ''
            modules:
              http_2xx:
                prober: http
                timeout: 30s
                http:
                  follow_redirects: true
                  preferred_ip_protocol: "ip4"

              tcp_connect:
                prober: tcp
                timeout: 30s
          '';
        };
      };
    };

    services.cadvisor = {
      enable = true;
      port = 9111;
    };
  };
}
