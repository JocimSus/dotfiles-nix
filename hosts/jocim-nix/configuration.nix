{
  inputs,
  config,
  pkgs,
  stdenv,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ../common.nix
    ];

  ## Graphics ##
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    # Currently using offload, need prime sync?
    # TODO: Forgor what this does
    powerManagement.finegrained = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";

        offload = {
            enable = true;
            enableOffloadCmd = true;
        };
      };
    };

  ## Desktop ##
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Use cache instead of building hyprland from source
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  ## User account ##
  users.users.jocim-nix = {
    isNormalUser = true;
    description = "jocim-nix";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  ## System programs ##
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    efibootmgr
    git
    kitty
  ];

}
