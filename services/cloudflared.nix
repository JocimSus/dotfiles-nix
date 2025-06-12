{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "648572fb-8580-447d-9c68-4bf0380ab7d8" = {
	credentialsFile = "/home/jocim-server/.cloudflared/648572fb-8580-447d-9c68-4bf0380ab7d8.json";
	ingress = {
	  "dash.224668.xyz" = {
	    service = "http://localhost:8082";
	  };
	  "224668.xyz" = {
	    service = "http://localhost:8080";
	  }; 
	};
	default = "http_status:404";
      };	
    };
  };
}
