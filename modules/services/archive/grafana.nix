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

  # hardware info
  services.prometheus = {
    enable = true;
    port = 9001;

    scrapeConfigs = [
      {
        job_name = "nodes";
        static_configs = [
          { targets = [ "100.73.72.65:9182" "100.91.185.102:9000" ]; }
        ];
      }
    ];
  };
}
