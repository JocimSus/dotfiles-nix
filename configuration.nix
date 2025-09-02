{
  pkgs,
  inputs,
  ...
}: {
  imports = [
      ./hardware-configuration.nix
      ./system.nix
      ./services
      inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/jocim-server/.config/sops/age/keys.txt";

  ## Users ##
  users.groups.media = {};
  users.users.calibre-server = {
    isSystemUser = true;
  };

  networking.hostName = "woof";
  users.users.jocim-server = {
    isNormalUser = true;
    description = "jocim-server";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    openssh.authorizedKeys.keyFiles = [
      ./authorized_keys/meow.pub
      ./authorized_keys/kaupec.pub
      ./authorized_keys/kaupec_phone.pub
      ./authorized_keys/meow_phone.pub
    ];
  };
  
  users.defaultUserShell = pkgs.zsh;

  ## System programs ##
  services.vscode-server.enable = true;
  programs.zsh.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 12345 ];

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
    (python312.withPackages (ps: with ps; [ 
       pip
    ]))    

    lunarvim

    nil
    gnumake
    nodejs_24
    cargo
    ripgrep

    sops
    git
    cloudflared

    cowsay
    lazygit

    go
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
      OnUnitActiveSec = "24h";
      Unit = "sync-gtnh.service";
    };
  };

  systemd.services.portfolio-website = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 5;
      WorkingDirectory = "/home/jocim-server/portfolio/";
      Environment = "PATH=/run/current-system/sw/bin:/run/current-system/profile/bin:/usr/local/bin:/usr/bin:/bin";
      ExecStart = [ "/home/jocim-server/.dotfiles/scripts/start-portfolio-website" ];
      User = "jocim-server";
    };
  };
}
