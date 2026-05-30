{
  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;

    settings = {
      server = [
        "1.1.1.1"
        "1.0.0.1"
      ];

      address = "/x.home/192.168.1.100";

      interface = "enp3s0";
      bind-interfaces = true;
    };
  };
}
