{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.woof.monitoring.enable {
    services.cadvisor = {
      enable = true;
      port = 9111;
    };

    services.prometheus.scrapeConfigs = [
      {
        job_name = "cadvisor";
        static_configs = [
          {
            targets = [ "localhost:${toString config.services.cadvisor.port}" ];
          }
        ];
      }
    ];
  };
}
