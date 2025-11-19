{
  services.homepage-dashboard = {
    enable = true;
    allowedHosts = "localhost:8082,127.0.0.1:8082,dash.224668.xyz";
    settings = {
      title = "sussy dashboard";
      description = "Hosted on my NixOS laptop.";
      theme = "dark";
      color = "slate";
      headerStyle = "boxedWidgets"; 
      layout = [
        {
          Cloud = {
            style = "row";
            columns = 4;
          };
        }
      ];
    };
    widgets = [
      {
        resources = {
	        label = "System";
	        cpu = true;
	        memory = true;
	        uptime = true;
	        refresh = "1000";
	        disk = "/";
	      };
      }
      {
	      resources = {
	        label = "External SSD";
	        disk = "/mnt/ssd1";
	      };
      }
    ];
    
    services = [
      {
        "Cloud" = [
          {
            "MicroBin" = {
              href = "https://microbin.224668.xyz";
            };
          }
          {
            "NextCloud" = {
              icon = "nextcloud.png";
              href = "https://nextcloud.224668.xyz";
              description = "Cloud in my home.";
              widget = {
                type = "nextcloud";
                url = "https://nextcloud.224668.xyz/ocs/v2.php/apps/serverinfo/api/v1/info?format=json";
              }; 
            };
          }
        ];
      }
    ];
  };
}
