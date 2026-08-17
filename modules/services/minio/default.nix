{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.woof.minio;
in
{
  options.woof.minio = {
    enable = lib.mkEnableOption "enable minio service";

    consoleDomain = lib.mkOption {
      type = lib.types.str;
      default = "minio-console.${config.woof.network.basePublicDomain}";
      example = "minio-console.${config.woof.network.basePublicDomain}";
      description = "public domain to access minio console";
    };

    listenDomain = lib.mkOption {
      type = lib.types.str;
      default = "minio.${config.woof.network.basePublicDomain}";
      example = "minio.${config.woof.network.basePublicDomain}";
      description = "listen domain to access minio api";
    };

    consolePort = lib.mkOption {
      type = lib.types.port;
      default = 9099;
      example = 9099;
    };

    listenPort = lib.mkOption {
      type = lib.types.port;
      default = 9100;
      example = 9100;
    };

    sops = {
      rootCredentialsFile = lib.mkOption {
        type = lib.types.str;
        default = "minio";
        example = "minio";
        description = "sops key for minio's root credentials";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.${cfg.sops.rootCredentialsFile} = { };

    services.minio = {
      enable = true;
      package = pkgs.minio.overrideAttrs (oldAttrs: rec {
        version = "2025-04-22T22-12-26Z";

        src = pkgs.fetchFromGitHub {
          owner = "minio";
          repo = "minio";
          rev = "RELEASE.${version}";
          hash = "sha256-BC633G27Zuhzk4DCLxtMGyWkQyo/3ObaIod7mDLPAqs=";
        };

        vendorHash = "sha256-F7texxlSLNVjhlAZPtYYnAd91FIF/BNpq7t1dLaDUpk=";
      });

      consoleAddress = ":${toString cfg.consolePort}";
      listenAddress = ":${toString cfg.listenPort}";
      region = "ap-southeast-1";

      rootCredentialsFile = config.sops.secrets.${cfg.sops.rootCredentialsFile}.path;
    };

    # Known issues:
    # - CVE-2026-40344: MinIO has an Unauthenticated Object Write via Missing Signature Verification in Unsigned-Trailer Uploads
    # - CVE-2026-41145: Unauthenticated Object Write via Query-String Credential Signature Bypass in Unsigned-Trailer Uploads
    # - CVE-2026-33322: JWT Algorithm Confusion in OIDC Authentication
    # - CVE-2026-33419: LDAP login brute-force via user enumeration and missing rate limit
    # - CVE-2026-34204: SSE Metadata Injection via Replication Headers
    # - CVE-2026-39414: DoS via Unbounded Memory Allocation in S3 Select CSV Parsing
    # - minio has been abandoned by upstream and security issues won't be fixed. Users should migrate to alternatives such as Garage, SeaweedFS, or Ceph. S3-compatible clients such as rclone can be used to move data.
    nixpkgs.config.permittedInsecurePackages = [
      "minio-2025-04-22T22-12-26Z"
    ];

    systemd.services.minio.environment = {
      MINIO_SERVER_URL = "https://${cfg.listenDomain}";
      MINIO_BROWSER_REDIRECT_URL = "https://${cfg.consoleDomain}";
    };

    services.nginx.virtualHosts = {
      ${cfg.consoleDomain} = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.consolePort}";
          proxyWebsockets = true;
        };
      };
      ${cfg.listenDomain} = {
        extraConfig = "client_max_body_size 1G;";
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.listenPort}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
