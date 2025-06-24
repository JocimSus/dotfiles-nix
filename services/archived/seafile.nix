{
  services.seafile = {
    enable = true;
    adminEmail = "joe.susatiyo@gmail.com";
    initialAdminPassword = "10110";

    ccnetSettings.General.SERVICE_URL = "https://files.224668.xyz";
    
    seahubAddress = "127.0.0.1:8088";
    seafileSettings.fileserver.port = 8089; 
  };
}
