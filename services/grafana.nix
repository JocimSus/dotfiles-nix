{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 8083;
        domain = "grafana.224668.xyz";
        serve_from_sub_path = true;
      };
    };
  };
}
