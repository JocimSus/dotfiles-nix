{
  services.seafile = {
    enable = false;
    adminEmail = "admin@mail.com";
    initialAdminPassword = "seafileAdmin";

    ccnetSettings.General.SERVICE_URL = "http://localhost:8087";
    
    seahubAddress = "0.0.0.0:8088";
    seafileSettings.fileserver.port = 8089; 
  };
}
