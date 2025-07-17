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
      (builtins.fetchTarball {
       url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-25.05/nixos-mailserver-nixos-25.05.tar.gz";
       sha256 = "0jpp086m839dz6xh6kw5r8iq0cm4nd691zixzy6z11c4z2vf8v85";
      })
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
}
