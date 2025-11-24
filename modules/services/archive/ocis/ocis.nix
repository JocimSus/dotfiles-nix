{
  services.ocis = {
    enable = true;
    port = 8091;
    url = "https://cloud.224668.xyz";
    configDir = "/var/lib/ocis/config";
    environment = {
      PROXY_TLS = "false";
      OCIS_LOG_LEVEL = "debug";
      OCIS_GRPC_MAX_RECEIVED_MESSAGE_SIZE = "1000000000";
      OCIS_GRPC_MAX_SEND_MESSAGE_SIZE = "1000000000";
      OCIS_LOG_LEVEL_storage_users = "debug";
      OCIS_LOG_LEVEL_postprocessing = "debug";
    };
  };
}
