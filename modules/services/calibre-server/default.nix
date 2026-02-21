{
  services.calibre-server = {
    enable = true;
    port = 8085;
    user = "calibre-server";
    group = "media";
    libraries = [ "/media/books" ];
    auth = {
      enable = true;
      mode = "basic";
      userDb = "/var/lib/calibre-server/users.sqlite";
    };
  };
}
