{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.woof.monitoring.enable {
    services.prometheus = {
      enable = true;
      port = 9090;
      globalConfig.scrape_interval = "10s";
    };
  };
}
