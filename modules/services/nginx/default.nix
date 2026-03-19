{
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    commonHttpConfig = ''
      set_real_ip_from 127.0.0.1;
      real_ip_header X-Forwarded-For;
      real_ip_recursive on;

      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header Forwarded "for=$remote_addr;proto=$scheme;host=$host";
      proxy_set_header X-Forwarded-Host $host;
      proxy_set_header X-Forwarded-Port $server_port;
    '';

    virtualHosts."_" = {
      default = true;
      locations."/".return = "404";
    };
  };
}
