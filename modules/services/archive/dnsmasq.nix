{
  services.dnsmasq = {
    enable = true;
    settings = {
      interface = [ "enp3s0" ]; 
      bind-interfaces = true;
      except-interface = [ "lo" ];
      listen-address = [ "192.168.1.9" ];
      address = [ "/cloud.local/192.168.1.9" ];
      no-hosts = true;
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts."cloud.local".extraConfig = ''
      reverse_proxy 192.168.1.9:8000
    '';
  };
}
