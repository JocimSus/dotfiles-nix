{
  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "enp3s0"; 
      bind-interfaces = true;
      address = [ "/cloud.local/192.168.1.9" ];
    };
  };
}
