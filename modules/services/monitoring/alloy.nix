{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.woof.monitoring.enable {
    services.alloy = {
      enable = true;
      configPath = "/etc/alloy"; # on config change service will not be restarted
    };

    systemd.services.alloy.serviceConfig = {
      SupplementaryGroups = [
        "adm"
      ];
    };

    environment.etc = {
      "alloy/loki.alloy".text = ''
        loki.write "loki" {
          endpoint {
            url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push"
          }
        }
      '';

      "alloy/systemd-relabel.alloy".text = ''
        loki.relabel "journal_filters" {
          forward_to = []

          rule {
            source_labels = ["__journal__systemd_unit"]
            target_label  = "unit"
          }

          rule {
            source_labels = ["__journal_syslog_identifier"]
            target_label  = "syslog_identifier"
          }

          rule {
            source_labels = ["__journal_priority_keyword"]
            target_label  = "level"
          }

          rule {
            source_labels = ["__journal__transport"]
            target_label  = "transport"
          }

          rule {
            source_labels = ["__journal__comm"]
            target_label  = "command"
          }
        }
      '';

      "alloy/systemd-journal.alloy".text = ''
        loki.source.journal "systemd_journal" {
          max_age       = "12h"
          relabel_rules = loki.relabel.journal_filters.rules
          forward_to    = [loki.write.loki.receiver]

          labels = {
            job  = "systemd-journal",
            host = "${config.networking.hostName}",
          }
        }
      '';
    };
  };
}
