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
  networking.hostName = "woof";
  users.users.jocim-server = {
    isNormalUser = true;
    description = "jocim-server";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  ## System programs ##
  environment.systemPackages = with pkgs; [
    ## Low Level ##

    ## Graphics ##

    ## Filesystem ##
    ntfs3g
    usbutils

    ## Terminal  ##
    unrar
    unzip
    p7zip

    btop-cuda
    lunarvim

    git
    gnumake
    cargo
    nodejs_24
    ripgrep
    lazygit
  ];

}
