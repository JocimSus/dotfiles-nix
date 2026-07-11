{
  config,
  ...
}:
{
  sops.secrets.CLOUDFLARE_DNS_API_TOKEN = {
    owner = "acme";
    group = "acme";
    mode = "0660";
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "jocimsus@jocimsus.tech";

    certs."jocimsus.tech" = {
      domain = "*.jocimsus.tech";
      dnsProvider = "cloudflare";
      credentialFiles = {
        "CLOUDFLARE_DNS_API_TOKEN_FILE" = config.sops.secrets.CLOUDFLARE_DNS_API_TOKEN.path;
      };

      reloadServices = [ "nginx" ];
    };
  };
}
