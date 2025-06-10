{
  pkgs,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ./common.nix
    ];

  ## System ##

  ## User account ##
  networking.firewall.allowedTCPPorts = [ 22 ];

  networking.hostName = "woof";
  users.users.jocim-server = {
    isNormalUser = true;
    description = "jocim-server";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keyFiles = [
	./authorized_keys/jocim-nix.pub
	./authorized_keys/kaupec.pub
    ];
  };

  ## System programs ##
  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
    usbutils
    p7zip

    btop
    vim

    git
  ];
  
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
	PasswordAuthentication = false;
    };
  };
}
