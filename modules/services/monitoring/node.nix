{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.woof.monitoring.enable {
    services.prometheus.exporters.node = {
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

    services.prometheus.scrapeConfigs = [
      {
        job_name = "woof";
        static_configs = [
          {
            targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
          }
        ];
      }
    ];
  };
}
