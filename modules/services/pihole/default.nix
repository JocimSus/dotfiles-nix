{
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
    ports = [ "8879" ];
  };
}
