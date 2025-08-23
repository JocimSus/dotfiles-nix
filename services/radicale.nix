{
  pkgs,
  ...
}:{
  environment.systemPackages = with pkgs; [
    apacheHttpd # for htpasswd
  ];

  services.radicale = {
    enable = true;
    settings = {
      server.hosts = [ "0.0.0.0:5232" ];
      auth = {
        type = "htpasswd";
        # make the file yourself
        # > htpasswd -B /var/lib/radicale/radicale_users <username>
        htpasswd_filename = "/var/lib/radicale/radicale_users";
        htpasswd_encryption = "bcrypt";
      };
    };
  };
}
