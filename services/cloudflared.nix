{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "648572fb-8580-447d-9c68-4bf0380ab7d8" = {
        credentialsFile = "/home/jocim-server/.cloudflared/648572fb-8580-447d-9c68-4bf0380ab7d8.json";
        ingress = {
          "cloud.224668.xyz" = {
            service = "http://localhost:8088";
          };
          "calibre.224668.xyz" = {
            service = "http://localhost:8085";
          };
          "vault.224668.xyz" = {
            service = "http://localhost:8222";
          };
          "paperless.224668.xyz" = {
            service = "http://localhost:28981";
          };
          "zip.224668.xyz" = {
            service = "http://localhost:8090";
          };
          # "gtnh.224668.xyz" = {
          #   service = "http://localhost:8016";
          # };
          "note.224668.xyz" = {
            service = "http://localhost:8017";
          };
          "books.224668.xyz" = {
            service = "http://localhost:8000";
          };

          "224668.xyz" = {
           service = "http://localhost:3000";
          };
        };
        default = "http_status:404";
      };	
    };
  };
}
