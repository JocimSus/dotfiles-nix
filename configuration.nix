{
  pkgs,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ./common.nix
    ];

  ## User account ##
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  networking.hostName = "woof";
  users.users.jocim-server = {
    isNormalUser = true;
    description = "jocim-server";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    openssh.authorizedKeys.keyFiles = [
	./authorized_keys/jocim-nix.pub
	./authorized_keys/kaupec.pub
    ];
  };

  ## System programs ##
  services.tailscale.enable = true;
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    usbutils
    p7zip
    
    screen

    btop
    vim
    kitty
    (python312.withPackages (ps: with ps; [ 
       
    ]))    

    git
    cloudflared

    cowsay

    lunarvim
    gnumake
    cargo
    nodejs_24
    ripgrep
    lazygit
  ];
  
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
	PasswordAuthentication = false;
	PermitRootLogin = "no";
    };
  };
}
