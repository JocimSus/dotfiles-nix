{ config
, ...
}: {
  sops.secrets."mailserverFile" = { };

  mailserver = {
    enable = true;
    fqdn = "mail.224668.xyz";
    domains = [ "224668.xyz" ];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "jocim@224668.xyz" = {
        hashedPasswordFile = config.sops.secrets."mailserverFile".path;
        aliases = [ "postmaster@224668.xyz" ];
      };
    };
  };

}
