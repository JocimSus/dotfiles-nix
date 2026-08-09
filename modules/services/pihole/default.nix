{
  config,
  lib,
  ...
}:
let
  cfg = config.woof.pihole;
in
{
  options.woof.pihole = {
    enable = lib.mkEnableOption "enable pihole service";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8879;
      example = 8879;
    };
  };

  config = lib.mkIf cfg.enable {
    services.pihole-ftl = {
      enable = true;
      useDnsmasqConfig = true;

      settings = {
        dns.upstreams = [
          "1.1.1.1"
          "1.0.0.1"
          "9.9.9.9"
        ];
        misc.dnsmasq_lines = [
          "address=/home/192.168.1.100"
          "server=/tail7d1457.ts.net/100.100.100.100"
        ];
      };

    };

    services.pihole-web = {
      enable = true;
      ports = [ cfg.port ];
    };
  };
}
