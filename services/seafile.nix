{
  config,
  ...
}:{
  sops.secrets."seafile/adminMail" = {};
  sops.secrets."seafile/adminPass" = {} ;

  services.seafile = {
    enable = true;
    adminEmail = config.sops.secrets."seafile/adminMail".path;
    initialAdminPassword = config.sops.secrets."seafile/adminPass".path;

    ccnetSettings.General.SERVICE_URL = "https://cloud.224668.xyz";
    
    seahubAddress = "127.0.0.1:8088";
    seafileSettings.fileserver.port = 8089; 
  };
}
