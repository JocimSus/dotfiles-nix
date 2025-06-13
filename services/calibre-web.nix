{
  services.calibre-web = {
    enable = true;
    user = "calibre-web";
    group = "media";

    listen = {
      ip = "127.0.0.1";
      port = 8086;
    };

    options = {
      calibreLibrary = "/media/books";
      enableBookUploading = true;
      enableBookConversion = true;
    };
  };
  
}
