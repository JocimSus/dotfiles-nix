{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.woof.monitoring.enable {
    services.prometheus.exporters.blackbox = {
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

    services.prometheus.scrapeConfigs = [
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
                toDomain = v: "https://${v}.${config.woof.network.basePublicDomain}";
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
            replacement = "localhost:${toString config.services.prometheus.exporters.blackbox.port}";
          }
        ];
      }
    ];
  };
}
