{
  pkgs,
  config,
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
    ];
  };

  ## System programs ##
  networking.firewall.allowedTCPPorts = [ 80 ];

  virtualisation.docker.enable = true;

  environment.variables = {
    EDITOR = "vim";
  };

  environment.systemPackages = with pkgs; [
    p7zip
    screen
    btop
    vim
    kitty
    unzip
    (python312.withPackages (ps: with ps; [ 
       
    ]))    

    sops
    git
    cloudflared

    cowsay
    lazygit

    go
  ];

  ## ts pmo
  systemd = {
    services.ts = {
      description = "ts ts ts ts ts";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = [ "/home/jocim-server/.dotfiles/scripts/reconnect-ethernet" ];
        User = "jocim-server";
      };
    };
    timers.ts = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "60min";
        OnUnitActiveSec = "60min";
        Unit = "ts.service";
      };
    };
  };

  ## this is for vscode-server
  services.vscode-server.enable = true;










}
