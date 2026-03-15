{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./system.nix

    # Essentials
    ../../modules/services/nginx
    ../../modules/services/cloudflared
    ../../modules/services/openssh
    ../../modules/services/tailscale
    ../../modules/services/dnsmasq
    ../../modules/system/sops

    # ../../containers/infrastructure/nginx
    # ../../containers/infrastructure/cloudflared

    ../../containers/databases/postgresql
    ../../containers/databases/redis

    # Services
    # ../../modules/services/nextcloud
    ../../modules/services/calibre-server
    # ../../modules/services/vaultwarden
    # ../../modules/services/zipline
    # ../../modules/services/hedgedoc
    ../../modules/services/audiobookshelf

    ../../containers/apps/nextcloud
    ../../containers/apps/vaultwarden
    ../../containers/apps/zipline
    ../../containers/apps/hedgedoc
  ];

  ## Sops ##
  sops.defaultSopsFile = ../../secrets/server/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/jocim-server/.config/sops/age/keys.txt";

  sops.secrets."nextcloud/adminPass" = {};
  sops.secrets."nextcloud/dbPass" = {};
  sops.secrets."nextcloud/redisNextcloudPass" = {};
  sops.secrets."redis/dbPass" = {};
  sops.secrets."vaultwardenEnv" = {};
  sops.secrets."ziplineEnv" = {};
  sops.secrets."hedgedocEnv" = {};

  ## Users ##
  users.groups.media = { };
  users.users.calibre-server = {
    isSystemUser = true;
  };

  networking.hostName = "woof";
  users.users.jocim-server = {
    isNormalUser = true;
    description = "jocim-server";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    openssh.authorizedKeys.keyFiles = [
      ./authorized_keys/meow.pub
      ./authorized_keys/kaupec.pub
      ./authorized_keys/kaupec_phone.pub
      ./authorized_keys/meow_phone.pub
    ];
  };

  users.defaultUserShell = pkgs.zsh;

  ## System programs ##
  programs.zsh.enable = true;
  # networking.firewall.allowedTCPPorts = [
  #   80
  #   443
  # ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8997 ];
    trustedInterfaces = [ "enp3s0" ];
  }; 

  virtualisation.docker.enable = true;

  environment.variables = {
    EDITOR = "vim";
  };

  environment.systemPackages = with pkgs; [
    jmtpfs
    usbutils
    p7zip
    screen
    btop
    vim
    kitty
    unzip
    (python312.withPackages (
      ps: with ps; [
        pip
      ]
    ))

    jdk25
    lunarvim

    nil
    gnumake
    nodejs_24
    cargo
    ripgrep
    pnpm
    yt-dlp

    sops
    git
    cloudflared

    cowsay
    lazygit

    go
    pgloader
  ];

  nix.settings = {
    substituters = [
      "https://prismlauncher.cachix.org"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-substituters = [
      "https://prismlauncher.cachix.org"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  systemd.services.sync-gtnh = {
    serviceConfig = {
      Type = "oneshot";
      Environment = "PATH=/run/current-system/sw/bin:/run/current-system/profile/bin:/usr/local/bin:/usr/bin:/bin";
      ExecStart = [ "/home/jocim-server/.dotfiles/scripts/sync-gtnh" ];
      User = "jocim-server";
    };
  };

  systemd.timers.sync-gtnh = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "6h";
      Unit = "sync-gtnh.service";
    };
  };

  systemd.services.yt-dlp-web = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 5;
      WorkingDirectory = "/home/jocim-server/yt-dlp_webui";
      Environment = "PATH=/run/current-system/sw/bin:/run/current-system/profile/bin:/usr/local/bin:/usr/bin:/bin";
      ExecStart = [ "/home/jocim-server/yt-dlp_webui/start-web" ];
      User = "jocim-server";
    };
  };

  systemd.services.yt-dlp-server = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 5;
      WorkingDirectory = "/home/jocim-server/yt-dlp_webui";
      Environment = "PATH=/run/current-system/sw/bin:/run/current-system/profile/bin:/usr/local/bin:/usr/bin:/bin";
      ExecStart = [ "/home/jocim-server/yt-dlp_webui/start-server" ];
      User = "jocim-server";
    };
  };

  # systemd.services.portfolio-website = {
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     Type = "simple";
  #     Restart = "always";
  #     RestartSec = 5;
  #     WorkingDirectory = "/home/jocim-server/portfolio/";
  #     Environment = "PATH=/run/current-system/sw/bin:/run/current-system/profile/bin:/usr/local/bin:/usr/bin:/bin";
  #     ExecStart = [ "/home/jocim-server/.dotfiles/scripts/start-portfolio-website" ];
  #     User = "jocim-server";
  #   };
  # };

  # systemd.services.hackathon-api = {
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     WorkingDirectory = "/home/jocim-server/hackathon/hackathon-api/";
  #     Environment = "PATH=/run/current-system/sw/bin:/run/current-system/profile/bin:/usr/local/bin:/usr/bin:/bin";
  #     ExecStart = [ "/home/jocim-server/hackathon/hackathon-api/docker-start.sh" ];
  #     User = "jocim-server";
  #   };
  # };

  # systemd.services.forms-api = {
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     WorkingDirectory = "/home/jocim-server/forms/backend/";
  #     Environment = "PATH=/run/current-system/sw/bin:/run/current-system/profile/bin:/usr/local/bin:/usr/bin:/bin";
  #     ExecStart = [ "/home/jocim-server/forms/backend/pnpm-start.sh" ];
  #     User = "jocim-server";
  #   };
  # };
}
