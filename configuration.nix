{
  pkgs,
  config,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ./system.nix
      ./services
    ];

  ## User account ##
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
    lazygit
  ];
}
