{
  environment.etc."motd".source = ./motd;
  services.openssh = {
    enable = true;
    ports = [ 22 443 ];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      PrintMotd = true;
    };
  };
}
